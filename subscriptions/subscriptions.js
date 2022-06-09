
// Pseudorandom nubmer genreator 
let randval = 123;

// Generates a pseudorandom number between 0 and 999.
function rand() {
  randval = randval * 9;
  randval = (randval / 1000) + (randval % 1000);
  return randval;
}

// Takes a chance, and returns true with the given probability.
function chance(probability) {
  let n = rand();
  return n < (1000.0 * probability);
}

let users = [...Array(1000).keys()].map(i => ({
  id: i,
  active: false,
  start: null,
  end: null,
}));

let dailyTotals = [];

var date = new Date(2022, 0, 1);
while (date.getFullYear() == 2022) {
  for (let user of users) {
    if (user.active) {
      if (chance(0.005)) {
        user.active = false;
        user.end = new Date(date.getTime());
      }
    } else {
      if (!user.start && chance(0.03)) {
        user.active = true;
        user.start = new Date(date.getTime());
      }
    }
  }

  dailyTotals.push(users.filter(user => user.active).length);
  date.setDate(date.getDate() + 1);
}

// Task: using the users array, recreate the dailyTotals array 
// that measures how many active subsribers there were on each day.
let myDailyTotals = [];

// your solution here
let total = 0;
date = new Date(2022, 0, 1);
while (date.getFullYear() == 2022) {
  for (let user of users) {
    if (user.start && user.start.getTime() == date.getTime()) {
      total++;
    }
    if (user.end && user.end.getTime() == date.getTime()) {
      total--;
    }   
  }
  myDailyTotals.push(total);
  date.setDate(date.getDate() + 1);
}
// end solution

if (dailyTotals.join(' ') == myDailyTotals.join(' ')) {
  console.log('Success!');
}
