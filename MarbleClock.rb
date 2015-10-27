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

  # tests if it's full and if not Adds a marble to the chute
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

  def count
    @data.size
  end

  def is_full
    result = @data.size >= @size
    # puts "    returning #{result} from is_full"
    result
  end

  # empties all the items in the chute into a queue
  def empty_into_main_queue
    # puts "  Emptying chute into queue."
    @@main += @data
    @data.clear
  end

  def print
    puts "Chute for #{@description}"
    puts @data
  end

  # The main queue is also a Chute, only there is one of them, not many
  def self.set_main_queue numMarbles
    # initialize dequeue with N number of marbles
    @@main = Array.new(numMarbles) { |i| Marble.new(i+1) }
  end

  def self.get_main_queue
    @@main
  end

  def self.pop_marble_off_main_queue
    @@main.shift
  end

  def self.push_marble_onto_main_queue(marble)
    @@main << marble
  end
end

class MarbleClock
  attr_reader :interval
  # param numMarbles- The number of marbles to initialize the clock with
  def initialize(numMarbles)
    # in integer seconds. How often to increment the clock
    @interval = 60

    # Let the chute hold the main dequeue as a class level variable to prevent
    # too numerous copying back as we push marbles on an off it.
    Chute.set_main_queue numMarbles

    @one_chute  = Chute.new(4, "one minute")
    @five_chute = Chute.new(11,"five minutes")
    @hour_chute = Chute.new(11,"one hour")
  end

  def print
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

  def run
    keep_going = true
    while keep_going do
      # pop marble off front of storage queue (dequeue)
      marble = Chute.pop_marble_off_main_queue
      sleep @interval
      #puts "-------------------------------------------------------"
      #puts "popping marble: #{marble}"

      # attempt      to push onto 1 minute chute
      if @one_chute.attempt_push(marble)
        print_time
        next
      # else attempt to push onto 5 minute chute
      elsif @five_chute.attempt_push(marble)
        print_time
        next
      # else attempt to push onto 1 hour   chute
      elsif @hour_chute.attempt_push(marble)
        print_time
        next
      # else falls through to bottom, put into dequeue
      else
        # puts "  Falls through back into main queue"
        Chute.push_marble_onto_main_queue marble
        @one_chute.empty_into_main_queue
        @five_chute.empty_into_main_queue
        @hour_chute.empty_into_main_queue
        print_time
        keep_going = false
      end
    end
  end
end

clock = MarbleClock.new(26)
clock.run