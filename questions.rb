require_relative 'MarbleClock'

# question 1
answer = 26

# question 2
clock = MarbleClock.new(26)
clock.interval = 0
clock.run
clock.print

# returns
# main queue
# Marble: 1
# Marble: 21
# Marble: 14
# Marble: 11
# Marble: 5
# Marble: 15
# Marble: 26
# Marble: 9
# Marble: 12
# Marble: 13
# Marble: 25
# Marble: 20
# Marble: 8
# Marble: 3
# Marble: 6
# Marble: 23
# Marble: 4
# Marble: 18
# Marble: 19
# Marble: 22
# Marble: 16
# Marble: 17
# Marble: 7
# Marble: 2#
# Marble: 10
# Marble: 24

# question 3
