// Here is a list of the people on our team.

// 1. What are the five most popular first names?

// 2. What are the five most popular last names?

// 3. Which "magic" names occur as both first and last names?

// 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

// 5. People are in a cluster if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a cluster of 3 people. Print the number of clusters of each size.

// 6. Do the results change if you add your name to the list?

// Diagram: https://andrewzc.net/interviews/names.pdf

let nameStrings = [
  ["Aaron", "Wilson"],
  ["Abhishek", "Sarihan"],
  ["Abigail", "Watson"],
  ["Adam", "Beckerman"],
  ["Adam", "Ochayon"],
  ["Adam", "Perea-Kane"],
  ["Aditya", "Mittal"],
  ["Aditya", "Risbud"],
  ["Alan", "Hu"],
  ["Alan", "Wang"],
  ["Alex", "Gates-Shannon"],
  ["Alex", "Meyers"],
  ["Alex", "Nelson"],
  ["Alexander", "Zaman"],
  ["Alexandre", "Petcherski"],
  ["Alexei", "Isac"],
  ["Alexis", "Moody"],
  ["Ali", "Weaver"],
  ["Alice", "Yoon"],
  ["Alissa", "Mittelberg"],
  ["Allen", "Garzone"],
  ["Allison", "Moore"],
  ["Allison", "Ng"],
  ["Amit", "Wadhera"],
  ["Amy", "Takata"],
  ["Andrea", "Dudla"],
  ["Andrew", "Garrett"],
  ["Andrew", "Whittaker"],
  ["Andrew", "Zamler-Carhart"],
  ["Andrey", "Patrov"],
  ["Andris", "Zvargulis"],
  ["Angel", "Dionisio"],
  ["Angelina", "Lam"],
  ["Anna", "Avrekh"],
  ["Anna", "Lee"],
  ["Anthony", "Escamilla"],
  ["Anthony", "Gonzales"],
  ["Anya", "Tran"],
  ["Aparna", "Parlapalli"],
  ["Ashley", "Murphy"],
  ["Ashrit", "Kamireddi"],
  ["Avraham", "Blaut"],
  ["Azfar", "Aziz"],
  ["Bart", "Karmilowicz"],
  ["Basia", "Mucha"],
  ["Bastien", "Falcou"],
  ["Beatrice", "Mendoza"],
  ["Ben", "Griffin"],
  ["Ben", "Hoyt"],
  ["Ben", "Huang"],
  ["Bernie", "Mulligan"],
  ["Bharath", "Swamy"],
  ["Bilal", "Siddiqui"],
  ["Bo", "Huang"],
  ["Bobby", "Singh"],
  ["Boris", "Veltman"],
  ["Brandon", "Kessler"],
  ["Brendan", "Stafford"],
  ["Brian", "Ha"],
  ["Brian", "Renzenbrink"],
  ["Brian", "Ross"],
  ["Brittany", "Chait"],
  ["Cade", "Cairns"],
  ["Calvin", "Lee"],
  ["Cameron", "Waeland"],
  ["Catarina", "Tsang"],
  ["Cevon", "Carver"],
  ["Chang", "Yu"],
  ["Charles", "Bai"],
  ["Charles", "Bentivenga"],
  ["Charles", "Bunton"],
  ["Charles", "Dannaker"],
  ["Chen", "Huang"],
  ["Chester", "Millisock"],
  ["Chi", "Ho"],
  ["Chiyi", "Wang"],
  ["Chloe", "Drew"],
  ["Chloe", "Powell"],
  ["Chong", "Qiu"],
  ["Chris", "Bejnar"],
  ["Chris", "Ewen"],
  ["Chris", "Lee"],
  ["Chris", "Seltzer"],
  ["Chrissy", "Oliver"],
  ["Christina", "Allen"],
  ["Cindy", "Zhang"],
  ["Claire", "Cipriani"],
  ["Cory", "Perkins"],
  ["Daljeet", "Kukreja"],
  ["Dan", "Clark"],
  ["Dan", "Edenhofer"],
  ["Dan", "McClure"],
  ["Dan", "Raykhlin"],
  ["Dana", "Bruschi"],
  ["Dani", "Dugan"],
  ["Dani", "Medina"],
  ["Daniel", "Epstein"],
  ["Daniel", "Han"],
  ["Daniel", "Sanchez"],
  ["Daniel", "Straus"],
  ["Danielle", "Shwed"],
  ["Danny", "Somekh"],
  ["Danylo", "Shpit"],
  ["Dave", "Barth"],
  ["Dave", "DeSandro"],
  ["David", "Mulatti"],
  ["David", "Shure"],
  ["Dean", "Hunt"],
  ["Didi", "Medina"],
  ["Dilip", "Gajendran"],
  ["Ding", "Zhou"],
  ["DiXi", "Qiao"],
  ["Djam", "Saidmuradov"],
  ["Don", "Hoang"],
  ["Donald", "Gray"],
  ["Dorian", "Manning"],
  ["Drew", "Libin"],
  ["Eda", "Kaplan"],
  ["Edward", "Hu"],
  ["Ellie", "Trulinger"],
  ["Emily", "Ho"],
  ["Emma", "Magaw"],
  ["Eric", "Beltran"],
  ["Erin", "Thwaites"],
  ["Etai", "Plushnick"],
  ["Ethan", "Fuld"],
  ["Evan", "Arbeitman"],
  ["Evan", "Compton"],
  ["Evgeny", "Semenov"],
  ["Eyal", "Maaravi"],
  ["Fabian", "Moya"],
  ["Fangbo", "Yang"],
  ["Felix", "Wei"],
  ["Foster", "Provost"],
  ["Freddy", "Munoz"],
  ["Fu", "Zhou"],
  ["Gabor", "Varga"],
  ["Gautam", "Narula"],
  ["Geet", "Bhanawat"],
  ["George", "Markantonis"],
  ["Grant", "Harper"],
  ["Greg", "Mushen"],
  ["Greg", "Scott"],
  ["Griffin", "Jones"],
  ["Hadar", "Yacobovitz"],
  ["Haiyang", "Si"],
  ["Han", "Chae"],
  ["Hao", "Jiang"],
  ["Harel", "Williams"],
  ["HeeMin", "Kim"],
  ["Henry", "Guo"],
  ["Henry", "Lee"],
  ["Henry", "Warren"],
  ["Henry", "Xu"],
  ["Herson", "Castillo"],
  ["Hiram", "Moncivais"],
  ["Hongwei", "Wang"],
  ["Hu", "Zhou"],
  ["Ian", "Cohan-Shapiro"],
  ["Ilya", "Timofeyev"],
  ["Jack", "Amadeo"],
  ["Jack", "Murphy"],
  ["Jackie", "Lynch"],
  ["Jackson", "Cheek"],
  ["Jaclyn", "Verga"],
  ["Jamal", "Carvalho"],
  ["James", "Chen"],
  ["James", "Manlapid"],
  ["Jane", "Calvin"],
  ["Jane", "Wang"],
  ["Jane", "Wang"],
  ["Jared", "Lindauer"],
  ["Jason", "Byck"],
  ["Jason", "LaCarrubba"],
  ["Jason", "Reid"],
  ["Jason", "Walker-Yung"],
  ["Jeffrey", "Tierney"],
  ["Jen", "Yuan"],
  ["Jennifer", "Cen"],
  ["Jeremy", "Huang"],
  ["Jeremy", "Schwartz"],
  ["Jessie", "Gong"],
  ["Jim", "Li"],
  ["Jim", "Zhan"],
  ["Jinbo", "Zhou"],
  ["Joanne", "Juan"],
  ["Joe", "Woodard"],
  ["John", "Gerhardt"],
  ["John", "Gold"],
  ["John", "Simon"],
  ["Jon", "Fu"],
  ["Jonathan", "Word"],
  ["Jonny", "Mooneyham"],
  ["Joseph", "Galindo"],
  ["Joseph", "Schmitt"],
  ["Joseph", "Sirosh"],
  ["Joseph", "Sortland"],
  ["Josh", "Attenberg"],
  ["Josh", "Burton"],
  ["Josh", "Nili"],
  ["Josh", "Stern"],
  ["Juan", "Ayala"],
  ["Julia", "Poladsky"],
  ["Julio", "Dionisio"],
  ["Junqi", "Liao"],
  ["Junyu", "Tian"],
  ["Justin", "Binns"],
  ["Justin", "Poston"],
  ["Kamal", "Behara"],
  ["Kari", "Oliveira"],
  ["Karl", "Jin"],
  ["Karthik", "Sangam"],
  ["Kashyap", "Dixit"],
  ["Kate", "McNulty"],
  ["Katy", "Hockerman"],
  ["Kayla", "Farrell"],
  ["Keith", "Rose"],
  ["Kelly", "Reed"],
  ["Kenneth", "Bergquist"],
  ["Kevin", "Baijnath"],
  ["Kevin", "Li"],
  ["Kevin", "Liu"],
  ["Kevin", "Reid"],
  ["Kevin", "Wong"],
  ["Khadija", "Ali"],
  ["Kim", "Nguyen"],
  ["Kim", "Nguyen"],
  ["Kim", "Nguyen"],
  ["Ksenia", "Coulter"],
  ["Kyle", "Rocco"],
  ["Kyler", "Cameron"],
  ["Lan", "Jiang"],
  ["Landin", "King"],
  ["Lauren", "Jones"],
  ["Lauren", "Wood"],
  ["Lee", "Pollard"],
  ["Leilah", "Williams"],
  ["Leo", "Yu"],
  ["Lihui", "Cai"],
  ["Lilly", "Ju"],
  ["Lindsay", "Owen"],
  ["Lucas", "Lain"],
  ["Lucas", "Reis"],
  ["Lucy", "Zhong"],
  ["Luigi", "Kapaj"],
  ["Luke", "Downey"],
  ["Luran", "He"],
  ["Lycurgo", "Vidalakis"],
  ["Margie", "Ruparel"],
  ["Mark", "Humphrey"],
  ["Martyna", "Michalska"],
  ["Mary", "Rabin"],
  ["Masha", "Malygina"],
  ["Matt", "Garza"],
  ["Matt", "Spangler"],
  ["Matthew", "Schoen"],
  ["Max", "Spinner"],
  ["Megan", "Clegg"],
  ["Melissa", "Delgado"],
  ["Michael", "Chen"],
  ["Michael", "Hansen"],
  ["Michael", "Lefco"],
  ["Michael", "Marion"],
  ["Michael", "Niday"],
  ["Michael", "Quinn"],
  ["Michael", "Walters"],
  ["Michael", "Wang"],
  ["Michaela", "Keady"],
  ["Michelle", "Yoon"],
  ["Min", "Zhang"],
  ["Miranda", "Ashley"],
  ["Monica", "Lee"],
  ["Moya", "Farvis"],
  ["Naader", "Khan"],
  ["Naomi", "Robert"],
  ["Nate", "Rentmeester"],
  ["Nathan", "Miranda"],
  ["Nathan", "Wang"],
  ["Nathaniel", "Brakeley"],
  ["Nathaniel", "Morihara"],
  ["Nicole", "Reinhardsen"],
  ["Nicole", "Yoblick"],
  ["Niko", "Mavrakis"],
  ["Nina", "Walker"],
  ["Ning", "Cui"],
  ["Noah", "Schwartz"],
  ["Octavio", "Roscioli"],
  ["Oliver", "Castillo"],
  ["Oliver", "Scott"],
  ["Ori", "Allon"],
  ["Ori", "Damary"],
  ["Osman", "Ozdemir"],
  ["Owen", "Charles"],
  ["Ozgur", "Akduran"],
  ["Pablo", "Mata"],
  ["Paola", "Justiniano"],
  ["Parth", "Patel"],
  ["Paul", "Brown"],
  ["Perry", "Yee"],
  ["Peter", "Liang"],
  ["Peter", "Liu"],
  ["Peter", "Ta"],
  ["Preetpal", "Phandar"],
  ["Raghav", "Sachdev"],
  ["Rahul", "Ratnakar"],
  ["Rahul", "Singh"],
  ["Raju", "Matta"],
  ["Ran", "Ding"],
  ["Raquel", "Bujans"],
  ["Ray", "Bueno"],
  ["Raymond", "Leung"],
  ["Raymond", "Wang"],
  ["Renato", "Gamboa"],
  ["Revathi", "Kandoji"],
  ["Rex", "Zhang"],
  ["Rich", "Pean"],
  ["Rich", "Simon"],
  ["Robert", "Gray"],
  ["Robert", "Reffkin"],
  ["Roger", "Geng"],
  ["Roger", "King"],
  ["Rohit", "Khanwani"],
  ["Rohit", "Kommareddy"],
  ["Rolando", "Penate"],
  ["Roman", "Blum"],
  ["Roman", "Valiouline"],
  ["Rong", "Chen"],
  ["Ross", "Bierbryer"],
  ["Russell", "Kaehler"],
  ["Russell", "Stephens"],
  ["Ruth", "Reffkin"],
  ["Ryan", "D'souza"],
  ["Ryan", "Houston"],
  ["Sagar", "Vora"],
  ["Saket", "Joshi"],
  ["Sam", "Lynch"],
  ["Sam", "Rowland"],
  ["Sam", "Sandoval"],
  ["Sam", "Stevens"],
  ["Sammy", "Shaar"],
  ["Samuel", "Rispaud"],
  ["Samuel", "Weiss"],
  ["Sana", "Sheikh"],
  ["Sarah", "Ahmed"],
  ["Sarah", "Jang"],
  ["Sarath", "Mantrala"],
  ["Sarita", "Goswami"],
  ["Satwik", "Seshasai"],
  ["Saurabh", "Shah"],
  ["Savanna", "Butterworth"],
  ["Savio", "Fernandes"],
  ["Scott", "Bierbryer"],
  ["Scott", "Block"],
  ["Scott", "Roepnack"],
  ["Sean", "Fitzell"],
  ["Sean", "Hallahan"],
  ["Sean", "Wheeler"],
  ["Shah", "Noor"],
  ["Shannon", "Sullivan"],
  ["Sharon", "Kapitula"],
  ["Sharon", "Kim"],
  ["Shauna", "Suthersan"],
  ["Shayaan", "Ali"],
  ["Shean", "Kim"],
  ["Shelley", "Zhong"],
  ["Shenzhi", "Li"],
  ["Shiloh", "Stuart"],
  ["Shirley", "Zhang"],
  ["Shiyang", "Fei"],
  ["Shiyuan", "Wang"],
  ["Siddharth", "Sarasvati"],
  ["Simon", "Thomas"],
  ["Siyuan", "Zhu"],
  ["Smriti", "Mehra"],
  ["Sohom", "Bhattacharya"],
  ["Stephanie", "Trimboli"],
  ["Stephen", "Spyropoulos"],
  ["Steve", "Zhu"],
  ["Steven", "Cheshire"],
  ["Sujit", "Poudel"],
  ["Tal", "Amitai"],
  ["Tal", "Netanyahu"],
  ["Tania", "Goswami"],
  ["Tao", "Xie"],
  ["Terry", "Zheng"],
  ["Theodore", "Rose"],
  ["Thomas", "Cardwell"],
  ["Thomas", "Hallock"],
  ["Thomas", "Tran"],
  ["Timothee", "Roussilhe"],
  ["Timothy", "Knox"],
  ["Todd", "Parmley"],
  ["Tong", "Li"],
  ["Tony", "Chung"],
  ["Tracy", "Miller"],
  ["Travis", "Van Belle"],
  ["Troy", "Crosby"],
  ["Tuan-Chun", "Chen"],
  ["Ugo", "DiGirolamo"],
  ["Veeru", "Namuduri"],
  ["Veronica", "Ray"],
  ["Vianna", "Vuong"],
  ["Victor", "Zhu"],
  ["Vincent", "Vuong"],
  ["Vivian", "Wong"],
  ["Warren", "Miller"],
  ["Wei", "Su"],
  ["Wei", "Wang"],
  ["Wen", "Ye"],
  ["Wes", "Billman"],
  ["Wes", "Vial"],
  ["Wes", "Zeng"],
  ["Will", "Decker"],
  ["William", "Bradley"],
  ["William", "Horton"],
  ["William", "Macarthur-Stanham"],
  ["Willy", "Wang"],
  ["Xi", "Lian"],
  ["Xianbin", "Wu"],
  ["Xiao", "Cui"],
  ["Xiaoguang", "Li"],
  ["Yang", "Zhang"],
  ["Yao", "Ding"],
  ["Yaron", "Schoen"],
  ["Yi", "Chen"],
  ["Ying", "Chen"],
  ["Yongjian", "Bi"],
  ["Yue", "Bi"],
  ["Yuvraj", "Vedvyas"],
  ["Yvonne", "Wang"],
  ["Zack", "Gao"],
  ["Zhenfei", "Tai"],
  ["Zhifeng", "Shi"],
  ["Zhixiang", "Ren"],
  ["Zhongxia", "Zhou"],
  ["Zhouqian", "Ma"],
  ["Zhuoyuan", "Zhang"],
  ["Zi", "Lian"],
  ["Zikang", "Yao"],
  ["Zoey", "Sun"],
  ["Zvi", "Band"]
];

let people = [];
let names = [];
let nameIndex = {};

// builds the graph network for people and names
for (let strings of nameStrings) {
  let first = getName(strings[0]);
  let last = getName(strings[1]);
  let person = {first, last};
  first.firsts.push(person);
  last.lasts.push(person);
  people.push(person);
}
names = Object.values(nameIndex);

console.log('Top first names:');
names.filter((name) => {
  return true; // TODO: find top first names
}).sort((a,b) => {
  return b.firsts.length - a.firsts.length;
}).slice(0,5).forEach(name => {
  console.log(name.name ,'-', getLastNames(name));
});

console.log('\nTop last names:');
names.filter((name) => {
  return true; // TODO: find top last names
}).sort((a,b) => {
  return b.lasts.length - a.lasts.length;
}).slice(0,5).forEach(name => {
  console.log(name.name, '-', getFirstNames(name));
});

console.log('\nMagic names:');
names.filter((name) => {
  return true; // TODO: find magic names
}).filter((name) => {
  return name.firsts.length && name.lasts.length;
}).sort((a,b) => {
  return (b.firsts.length + b.lasts.length) -
         (a.firsts.length + a.lasts.length);
}).forEach(name => {
  console.log(name.name, '-', getFirstNames(name), '/', getLastNames(name));
});

console.log('\nMagic people:');
people.filter((person) => {
  return true; // TODO: find magic people
}).filter((person) => {
  return person.first.lasts.length && person.last.firsts.length;
}).forEach(person => {
  console.log(person.first.name, person.last.name);
});

console.log('\nCluster sizes:');
let clusterSizes = {};
// TODO: update clusterSizes
names.forEach((name) => {
  let count = countName(name);
  if (count) clusterSizes[count] = (clusterSizes[count] || 0) + 1;
});
console.log(clusterSizes);

function countName(name) {
  if (name.visited) return 0;
  name.visited = true;
  return [...name.firsts, ...name.lasts]
    .reduce((total, person) => total + countPerson(person), 0);
}

function countPerson(person) {
  if (person.visited) return 0;
  person.visited = true;
  return 1 + countName(person.first) + countName(person.last);
}

// TODO: add your name to the list and see if the results change!

// gets the name with the given value,
// or creates a new one if it wasn't found
function getName(value) {
  let name = nameIndex[value];
  if (!name) {
    name = {name: value, firsts: [], lasts: []};
    nameIndex[value] = name;
  }
  return name;
}

// returns a string with the first names of everyone
// who has the given name as their last name
function getFirstNames(name) {
  return name.lasts.map(person => person.first.name).join(', ');
}

// returns a string with the last names of everyone
// who has the given name as their first name
function getLastNames(name) {
  return name.firsts.map(person => person.last.name).join(', ');
}
