# ------------------------------------------------------------------
#
# Marble Ball Clock
#
# By Christopher3d@hotmail.com
# Copyright: October 2015
#
# How to use:
# First instantiate class MarbleClock, passing in the number of
# marbles to operate it with. The minimum number of marbles needed
# to run it is 26 by the way.
# Then call run:
#
# clock = MarbleClock.new(26)
# clock.run
#
# ------------------------------------------------------------------

# Represents a marble.
# It holds an integer variable to identify the marble, so I can see the
# order of marbles in the different chutes and queues.
class Marble
  attr_reader :value
  # initialize with an integer value
  def initialize(val)
    @value = val
  end
  def to_s
    "Marble: #{@value}"
  end
end

# Wraps an array that holds a few marbles. Build to represent a double ended queue.
# Marbles are placed in the back of the array using method <<
# Marbles are emptied out the front
class Chute
  def initialize(size,description)
    @data = []
    @size = size
    @description = description
  end

  # tests if it's full and if not full, adds a marble to the chute
  # returns false if the array is full, true if the array is NOT full
  def attempt_push(marble)
    # puts "  attempting to push into chute #{@description}. @data.size:#{@data.size}, given size: #{@size}"
    if @data.size >= @size
      # puts "    full. @data size: #{@data.size}"
      #full
      empty_into_main_queue
      false
    else
      @data << marble
      # puts "    not full. data size: #{@data.size}"
      true
    end
  end

  # returns the number of marbles in the chute
  def count
    @data.size
  end

  # returns true if the chute is full, false if the chute is not full.
  def is_full
    result = @data.size >= @size
    # puts "    returning #{result} from is_full"
    result
  end

  # empties all the items in the chute into a queue
  def empty_into_main_queue
    # puts "  Emptying chute into queue."
    @@main += @data.reverse
    @data.clear
  end

  # useful for testing and debugging
  def print
    puts "Chute for #{@description}"
    puts @data
  end

  def to_json
    @data.collect { |m| m.value }
  end

  # The main queue is also a Chute, there is one of them, not many
  # so this is held as a class level variable
  # It's represented like a double ended queue where items are popped
  # off the front and pushed on the back
  def self.set_main_queue numMarbles
    @@numMarbles = numMarbles
    # initialize dequeue with N number of marbles
    @@main = Array.new(numMarbles) { |i| Marble.new(i+1) }
  end

  def self.get_main_queue
    @@main
  end

  def self.pop_marble_off_main_queue
    result = @@main.shift
    unless result
      puts "marble is nil"
    end
    result
  end

  def self.push_marble_onto_main_queue(marble)
    @@main << marble
  end

  def self.main_queue_sorted?
    @@main.each_cons(2).all? { |a,b|
      a.value < b.value
    }
  end

  def self.original_order?
    if (@@main.count == @@numMarbles) && main_queue_sorted?
      return true
    end
    false
  end

  def self.to_json
    @@main.collect { |m| m.value }
  end
end

# The marble clock instance itself. The top level class for instantiating
# and running the clock. Runs for 12 hours only (I had no mandate to make it run longer).
class MarbleClock
  attr_accessor :interval
  # param numMarbles- The number of marbles to initialize the clock with
  def initialize(numMarbles, minutes_max = 0)
    # in integer seconds. How often to increment the clock
    @interval = 60
    @max_run_time = minutes_max
    # Let the chute hold the main dequeue as a class level variable to prevent
    # too numerous copying back as we push marbles on an off it.
    Chute.set_main_queue numMarbles

    @one_chute  = Chute.new(4, "one minute")
    @five_chute = Chute.new(11,"five minutes")
    @hour_chute = Chute.new(11,"one hour")
  end

  def print_chutes
    puts "main queue"
    puts Chute.get_main_queue
    @one_chute.print
    @five_chute.print
    @hour_chute.print
  end

  def print_time
    hours   = format('%02d', @hour_chute.count)
    minutes = format('%02d', (@five_chute.count * 5) + (@one_chute.count))
    puts "#{hours}:#{minutes}"
  end

  def print_days
    days = @twelve_hours_increments / 2
    rem  = @twelve_hours_increments % 2
    hours= rem * 12
    puts "days: #{days}, hours: #{hours}"
  end

  def print_json
    puts "{\"Minutes\": #{@one_chute.to_json}, \"FiveMinutes\": #{@five_chute.to_json}, \"Hours\": #{@hour_chute.to_json}, \"Queue\": #{Chute.to_json}}"
  end

  # Call this to start the clock.
  # It will print out the time every minute.
  def run(find_original_order = false)
    @twelve_hours_increments = 0 if find_original_order
    numMinutesTotal = 0 if @max_run_time
    keep_going = true
    while keep_going do
      # pop marble off front of storage queue (dequeue)
      marble = Chute.pop_marble_off_main_queue
      if @interval > 0
        sleep @interval
      end
      if @max_run_time
        numMinutesTotal += 1
        if numMinutesTotal == @max_run_time
          break
        end
      end
      #puts "-------------------------------------------------------"
      #puts "popping marble: #{marble}"

      # attempt      to push onto 1 minute chute
      if @one_chute.attempt_push(marble)
        print_time unless @interval == 0
        next
      # else attempt to push onto 5 minute chute
      elsif @five_chute.attempt_push(marble)
        print_time unless @interval == 0
        next
      # else attempt to push onto 1 hour   chute
      elsif @hour_chute.attempt_push(marble)
        print_time unless @interval == 0
        next
      # else falls through to bottom, put into dequeue
      else
        # puts "  Falls through back into main queue"
        Chute.push_marble_onto_main_queue marble
        @one_chute.empty_into_main_queue
        @five_chute.empty_into_main_queue
        @hour_chute.empty_into_main_queue
        print_time unless @interval == 0
        @twelve_hours_increments += 1 if find_original_order
        keep_going = false unless find_original_order
        if find_original_order && Chute.original_order?
          # for question 3
          break
        end
      end
    end
  end
end
