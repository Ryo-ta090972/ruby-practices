require "date"
require 'optparse'

#---定数---
Day_of_week = ["日" ,"月" ,"火" ,"水" ,"木" ,"金" ,"土" ]
Default_Width = 3
BackgroundColor_red = "\e[41m"
ResetColor = "\e[0m"

#---初期設定---
now_date = Date.today
target_year = now_date.year
target_month = now_date.month
width = Default_Width

#---コマンドラインのオプション設定---
opt = OptionParser.new
opt.on('-y [VAL]', '--year [VAL]') {|y| target_year = y.to_i}
opt.on('-m [VAL]', '--month [VAL]') {|m| target_month = m.to_i} 
opt.on('-w [VAL]', '--width [VAL]') {|w| width = w.to_i} 
opt.parse!(ARGV)

#---幅の設定---
width_header = "%#{width * 3}s" 
width_full = "%#{width - 1}s"
width_half = "%#{width}s"

#---月初の日付、月末の日付と数字を取得---
beginning_of_month = Date.new(target_year, target_month, 1 )
end_of_month = Date.new(target_year, target_month, -1 )
end_number = end_of_month.day

#---フォーマット付き出力メソッド---
def format_print(subject_date, now_date, end_number, width_half)
    print BackgroundColor_red if subject_date == now_date
    print sprintf(width_half, subject_date.day)
    print ResetColor if subject_date == now_date
    puts if subject_date.saturday? || subject_date.day == end_number #改行（printメソッドで終わると%が表示される） 
end

#--------------------------
#------カレンダー作成------
#--------------------------

#---指定の年月を配置---
print sprintf(width_header, target_month.to_s + "月 ")
puts target_year

#---曜日の配置---
Day_of_week.each do |text|
    print sprintf(width_full, text)
    puts if text == Day_of_week.last  #改行
end

#---月初のインデント配置---
indent = beginning_of_month.wday * width
indent.times {print " "}

#---日付の配置---
i = 0
while i < end_number do
    subject_date = beginning_of_month + i

    format_print(subject_date, now_date, end_number, width_half)
    
    i += 1
end
