function makeMonth(month: number, year: number): Array<Array<number>> {
  let weeks = new Array<Array<number>>();
  let date = new Date(year, month - 1, 1);
  let last = new Date(year, month, 0);
      
  while (date.getDay() > 0) {
    date.setDate(date.getDate() - 1);
  }
  
  while (date <= last) {
    let week = new Array<number>();
    for (let i = 0; i < 7; i++) {
      week.push(date.getDate());
      date.setDate(date.getDate() + 1);
    }
    weeks.push(week);
  }
  return weeks;
}

let weeks = makeMonth(12, 2021);
for (let week of weeks) {
  console.log(week.join(", "));
}

if (makeMonth(2, 2015).length == 4) {
  console.log("Feb 2015 has 4 weeks");
}
if (makeMonth(4, 2021).length == 5) {
  console.log("Apr 2021 has 5 weeks");
}
if (makeMonth(5, 2021).length == 6) {
  console.log("May 2021 has 6 weeks");
}

