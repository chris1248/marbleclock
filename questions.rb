require_relative 'MarbleClock'

puts "----------------------------------------"
puts "# question 1"
puts "answer = 27"

puts "----------------------------------------"
puts "# question 2"
clock = MarbleClock.new(27)
clock.interval = 0 # don't want to wait a real 12 hours for this to run
clock.run
clock.print_chutes

# returns
# main queue
# Marble: 3
# Marble: 26
# Marble: 13
# Marble: 2
# Marble: 21
# Marble: 16#
# Marble: 8
# Marble: 14
# Marble: 6
# Marble: 18
# Marble: 5
# Marble: 12
# Marble: 10
# Marble: 11
# Marble: 9
# Marble: 4
# Marble: 23
# Marble: 19
# Marble: 25
# Marble: 1
# Marble: 27
# Marble: 22
# Marble: 17
# Marble: 7
# Marble: 15
# Marble: 24
# Marble: 20

puts "----------------------------------------"
puts "# question 3"
clock = MarbleClock.new(27)
clock.interval = 0 # don't want to wait a real 12 hours for this to run
clock.run(find_original_order = true)
clock.print_days

# returns
# days: 23, hours: 0

puts "----------------------------------------"
puts "# question 4"
clock = MarbleClock.new(27, 193)
clock.interval = 0 # don't want to wait a real 12 hours for this to run
clock.run
clock.print_json
