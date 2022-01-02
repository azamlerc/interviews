require 'date'

def makeMonth(month, year)
  weeks = []
  date = Date.new(year, month, 1)
  last = date.next_month.prev_day
  
  while date.wday > 0
    date = date.prev_day
  end

  while date <= last 
    week = []
    7.times do
      week.append(date.day)
      date = date.next_day
    end
    weeks.append(week)
  end
    
  return weeks
end

weeks = makeMonth(12, 2021)
weeks.each do |week|
  puts week.join(" ")
end

if makeMonth(2, 2015).count == 4
  puts "Feb 2015 has 4 weeks"
end
if makeMonth(4, 2021).count == 5
  puts "Apr 2021 has 5 weeks"
end
if makeMonth(5, 2021).count == 6
  puts "May 2021 has 6 weeks"
end
