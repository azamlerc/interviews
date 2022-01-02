import Foundation

let calendar = Calendar(identifier: .gregorian)

func makeMonth(month: Int, year: Int) -> [[Int]] {
  var weeks = [[Int]]()
  var date = calendar.date(from: DateComponents(year: year, month: month))!
  let last = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: date)!
  
  while calendar.component(.weekday, from: date) > 1 {
    date = calendar.date(byAdding: .day, value: -1, to: date, wrappingComponents: false)!
  }
  while date <= last {
    var week = [Int]()
    for _ in 1...7 {
      week.append(calendar.component(.day, from: date))
      date = calendar.date(byAdding: .day, value: 1, to: date, wrappingComponents: false)!
    }
    weeks.append(week)
  }
  return weeks
}

let weeks = makeMonth(month: 12, year: 2021)
for week in weeks {
  print("\(week)")
}

if makeMonth(month: 2, year: 2015).count == 4 {
  print("Feb 2015 has 4 weeks")
}
if makeMonth(month: 4, year: 2021).count == 5 {
  print("Apr 2021 has 5 weeks")
}
if makeMonth(month: 5, year: 2021).count == 6 {
  print("May 2021 has 6 weeks")
}
