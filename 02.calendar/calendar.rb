require "date"
require 'optparse'

DAY_OF_WEEK = ["日" ,"月" ,"火" ,"水" ,"木" ,"金" ,"土" ]
WIDTH_HALF = 3
WIDTH_FULL = 2
INDENT_HEADER = 10
SET_COLOR_REVERSAL = "\e[7m"
RESET_COLOR = "\e[0m"

today = Date.today
target_year = today.year
target_month = today.month

opt = OptionParser.new
opt.on('-y [VAL]', '--year [VAL]') {|y| target_year = y.to_i}
opt.on('-m [VAL]', '--month [VAL]') {|m| target_month = m.to_i} 
opt.parse!(ARGV)

beginning_of_month = Date.new(target_year, target_month, 1 )
end_of_month = Date.new(target_year, target_month, -1 )

def format_print(day, today, end_of_month)
    print SET_COLOR_REVERSAL if day == today
    print day.day.to_s.rjust(WIDTH_HALF)
    print RESET_COLOR if day == today
    puts if day.saturday?
end

print (target_month.to_s + "月 ").rjust(INDENT_HEADER)
puts target_year

DAY_OF_WEEK.each do |text|
    print text.rjust(WIDTH_FULL)
end
puts

indent_beginning_month = beginning_of_month.wday * WIDTH_HALF
indent_beginning_month.times {print " "}

(beginning_of_month..end_of_month).each do |day|
    format_print(day, today, end_of_month)
end
puts
