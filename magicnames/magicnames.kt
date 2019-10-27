// Here is a list of the people on our team.

// 1. What are the five most popular first names?

// 2. What are the five most popular last names?

// 3. Which "magic" names occur as both first and last names?

// 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

// 5. People are in a group if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a group of 3 people. Print the number of groups of each size.
  
// 6. Do the results change if you add your name to the list?

// Diagram: https://andrewzc.net/interviews/names.pdf

import Foundation

val nameStrings = listOf(
  listOf("Aaron", "Wilson"),
  listOf("Abhishek", "Sarihan"),
  listOf("Abigail", "Watson"),
  listOf("Adam", "Beckerman"),
  listOf("Adam", "Ochayon"),
  listOf("Adam", "Perea-Kane"),
  listOf("Aditya", "Mittal"),
  listOf("Aditya", "Risbud"),
  listOf("Alan", "Hu"),
  listOf("Alan", "Wang"),
  listOf("Alex", "Gates-Shannon"),
  listOf("Alex", "Meyers"),
  listOf("Alex", "Nelson"),
  listOf("Alexander", "Zaman"),
  listOf("Alexandre", "Petcherski"),
  listOf("Alexei", "Isac"),
  listOf("Alexis", "Moody"),
  listOf("Ali", "Weaver"),
  listOf("Alice", "Yoon"),
  listOf("Alissa", "Mittelberg"),
  listOf("Allen", "Garzone"),
  listOf("Allison", "Moore"),
  listOf("Allison", "Ng"),
  listOf("Amit", "Wadhera"),
  listOf("Amy", "Takata"),
  listOf("Andrea", "Dudla"),
  listOf("Andrew", "Garrett"),
  listOf("Andrew", "Whittaker"),
  listOf("Andrew", "Zamler-Carhart"),
  listOf("Andrey", "Patrov"),
  listOf("Andris", "Zvargulis"),
  listOf("Angel", "Dionisio"),
  listOf("Angelina", "Lam"),
  listOf("Anna", "Avrekh"),
  listOf("Anna", "Lee"),
  listOf("Anthony", "Escamilla"),
  listOf("Anthony", "Gonzales"),
  listOf("Anya", "Tran"),
  listOf("Aparna", "Parlapalli"),
  listOf("Ashley", "Murphy"),
  listOf("Ashrit", "Kamireddi"),
  listOf("Avraham", "Blaut"),
  listOf("Azfar", "Aziz"),
  listOf("Bart", "Karmilowicz"),
  listOf("Basia", "Mucha"),
  listOf("Bastien", "Falcou"),
  listOf("Beatrice", "Mendoza"),
  listOf("Ben", "Griffin"),
  listOf("Ben", "Hoyt"),
  listOf("Ben", "Huang"),
  listOf("Bernie", "Mulligan"),
  listOf("Bharath", "Swamy"),
  listOf("Bilal", "Siddiqui"),
  listOf("Bo", "Huang"),
  listOf("Bobby", "Singh"),
  listOf("Boris", "Veltman"),
  listOf("Brandon", "Kessler"),
  listOf("Brendan", "Stafford"),
  listOf("Brian", "Ha"),
  listOf("Brian", "Renzenbrink"),
  listOf("Brian", "Ross"),
  listOf("Brittany", "Chait"),
  listOf("Cade", "Cairns"),
  listOf("Calvin", "Lee"),
  listOf("Cameron", "Waeland"),
  listOf("Catarina", "Tsang"),
  listOf("Cevon", "Carver"),
  listOf("Chang", "Yu"),
  listOf("Charles", "Bai"),
  listOf("Charles", "Bentivenga"),
  listOf("Charles", "Bunton"),
  listOf("Charles", "Dannaker"),
  listOf("Chen", "Huang"),
  listOf("Chester", "Millisock"),
  listOf("Chi", "Ho"),
  listOf("Chiyi", "Wang"),
  listOf("Chloe", "Drew"),
  listOf("Chloe", "Powell"),
  listOf("Chong", "Qiu"),
  listOf("Chris", "Bejnar"),
  listOf("Chris", "Ewen"),
  listOf("Chris", "Lee"),
  listOf("Chris", "Seltzer"),
  listOf("Chrissy", "Oliver"),
  listOf("Christina", "Allen"),
  listOf("Cindy", "Zhang"),
  listOf("Claire", "Cipriani"),
  listOf("Cory", "Perkins"),
  listOf("Daljeet", "Kukreja"),
  listOf("Dan", "Clark"),
  listOf("Dan", "Edenhofer"),
  listOf("Dan", "McClure"),
  listOf("Dan", "Raykhlin"),
  listOf("Dana", "Bruschi"),
  listOf("Daniel", "Epstein"),
  listOf("Daniel", "Han"),
  listOf("Daniel", "Sanchez"),
  listOf("Daniel", "Straus"),
  listOf("Danielle", "Shwed"),
  listOf("Danny", "Somekh"),
  listOf("Danylo", "Shpit"),
  listOf("Dave", "Barth"),
  listOf("Dave", "DeSandro"),
  listOf("David", "Mulatti"),
  listOf("David", "Shure"),
  listOf("Dean", "Hunt"),
  listOf("Dilip", "Gajendran"),
  listOf("Ding", "Zhou"),
  listOf("DiXi", "Qiao"),
  listOf("Djam", "Saidmuradov"),
  listOf("Don", "Hoang"),
  listOf("Donald", "Gray"),
  listOf("Dorian", "Manning"),
  listOf("Drew", "Libin"),
  listOf("Eda", "Kaplan"),
  listOf("Edward", "Hu"),
  listOf("Ellie", "Trulinger"),
  listOf("Emily", "Ho"),
  listOf("Emma", "Magaw"),
  listOf("Eric", "Beltran"),
  listOf("Erin", "Thwaites"),
  listOf("Etai", "Plushnick"),
  listOf("Ethan", "Fuld"),
  listOf("Evan", "Arbeitman"),
  listOf("Evan", "Compton"),
  listOf("Evgeny", "Semenov"),
  listOf("Eyal", "Maaravi"),
  listOf("Fabian", "Moya"),
  listOf("Fangbo", "Yang"),
  listOf("Felix", "Wei"),
  listOf("Foster", "Provost"),
  listOf("Freddy", "Munoz"),
  listOf("Fu", "Zhou"),
  listOf("Gabor", "Varga"),
  listOf("Gautam", "Narula"),
  listOf("Geet", "Bhanawat"),
  listOf("George", "Markantonis"),
  listOf("Grant", "Harper"),
  listOf("Greg", "Mushen"),
  listOf("Greg", "Scott"),
  listOf("Griffin", "Jones"),
  listOf("Hadar", "Yacobovitz"),
  listOf("Haiyang", "Si"),
  listOf("Han", "Chae"),
  listOf("Hao", "Jiang"),
  listOf("Harel", "Williams"),
  listOf("HeeMin", "Kim"),
  listOf("Henry", "Guo"),
  listOf("Henry", "Lee"),
  listOf("Henry", "Warren"),
  listOf("Henry", "Xu"),
  listOf("Herson", "Castillo"),
  listOf("Hiram", "Moncivais"),
  listOf("Hongwei", "Wang"),
  listOf("Hu", "Zhou"),
  listOf("Ian", "Cohan-Shapiro"),
  listOf("Ilya", "Timofeyev"),
  listOf("Jack", "Amadeo"),
  listOf("Jack", "Murphy"),
  listOf("Jackie", "Lynch"),
  listOf("Jackson", "Cheek"),
  listOf("Jaclyn", "Verga"),
  listOf("Jamal", "Carvalho"),
  listOf("James", "Chen"),
  listOf("James", "Manlapid"),
  listOf("Jane", "Calvin"),
  listOf("Jane", "Wang"),
  listOf("Jane", "Wang"),
  listOf("Jared", "Lindauer"),
  listOf("Jason", "Byck"),
  listOf("Jason", "LaCarrubba"),
  listOf("Jason", "Reid"),
  listOf("Jason", "Walker-Yung"),
  listOf("Jeffrey", "Tierney"),
  listOf("Jen", "Yuan"),
  listOf("Jennifer", "Cen"),
  listOf("Jeremy", "Huang"),
  listOf("Jeremy", "Schwartz"),
  listOf("Jessie", "Gong"),
  listOf("Jim", "Li"),
  listOf("Jim", "Zhan"),
  listOf("Jinbo", "Zhou"),
  listOf("Joanne", "Juan"),
  listOf("Joe", "Woodard"),
  listOf("John", "Gerhardt"),
  listOf("John", "Gold"),
  listOf("John", "Simon"),
  listOf("Jon", "Fu"),
  listOf("Jonathan", "Word"),
  listOf("Jonny", "Mooneyham"),
  listOf("Joseph", "Galindo"),
  listOf("Joseph", "Schmitt"),
  listOf("Joseph", "Sirosh"),
  listOf("Joseph", "Sortland"),
  listOf("Josh", "Attenberg"),
  listOf("Josh", "Burton"),
  listOf("Josh", "Nili"),
  listOf("Josh", "Stern"),
  listOf("Juan", "Ayala"),
  listOf("Julia", "Poladsky"),
  listOf("Julio", "Dionisio"),
  listOf("Junqi", "Liao"),
  listOf("Junyu", "Tian"),
  listOf("Justin", "Binns"),
  listOf("Justin", "Poston"),
  listOf("Kamal", "Behara"),
  listOf("Kari", "Oliveira"),
  listOf("Karl", "Jin"),
  listOf("Karthik", "Sangam"),
  listOf("Kashyap", "Dixit"),
  listOf("Kate", "McNulty"),
  listOf("Katy", "Hockerman"),
  listOf("Kayla", "Farrell"),
  listOf("Keith", "Rose"),
  listOf("Kelly", "Reed"),
  listOf("Kenneth", "Bergquist"),
  listOf("Kevin", "Baijnath"),
  listOf("Kevin", "Li"),
  listOf("Kevin", "Liu"),
  listOf("Kevin", "Reid"),
  listOf("Kevin", "Wong"),
  listOf("Khadija", "Ali"),
  listOf("Kim", "Nguyen"),
  listOf("Kim", "Nguyen"),
  listOf("Kim", "Nguyen"),
  listOf("Ksenia", "Coulter"),
  listOf("Kyle", "Rocco"),
  listOf("Kyler", "Cameron"), 
  listOf("Lan", "Jiang"),
  listOf("Landin", "King"),
  listOf("Lauren", "Jones"),
  listOf("Lauren", "Wood"),
  listOf("Lee", "Pollard"),
  listOf("Leilah", "Williams"),
  listOf("Leo", "Yu"),
  listOf("Lihui", "Cai"),
  listOf("Lilly", "Ju"),
  listOf("Lindsay", "Owen"),
  listOf("Lucas", "Lain"),
  listOf("Lucas", "Reis"),
  listOf("Lucy", "Zhong"),
  listOf("Luigi", "Kapaj"),
  listOf("Luke", "Downey"),
  listOf("Luran", "He"),
  listOf("Lycurgo", "Vidalakis"),
  listOf("Margie", "Ruparel"),
  listOf("Mark", "Humphrey"),
  listOf("Martyna", "Michalska"),
  listOf("Mary", "Rabin"),
  listOf("Masha", "Malygina"),
  listOf("Matt", "Garza"),
  listOf("Matt", "Spangler"),
  listOf("Matthew", "Schoen"),
  listOf("Max", "Spinner"),
  listOf("Megan", "Clegg"),
  listOf("Melissa", "Delgado"),
  listOf("Michael", "Chen"),
  listOf("Michael", "Hansen"),
  listOf("Michael", "Lefco"),
  listOf("Michael", "Marion"),
  listOf("Michael", "Niday"),
  listOf("Michael", "Quinn"),
  listOf("Michael", "Walters"),
  listOf("Michael", "Wang"),
  listOf("Michaela", "Keady"),
  listOf("Michelle", "Yoon"),
  listOf("Min", "Zhang"),
  listOf("Miranda", "Ashley"),
  listOf("Monica", "Lee"),
  listOf("Moya", "Farvis"),
  listOf("Naader", "Khan"),
  listOf("Naomi", "Robert"),
  listOf("Nate", "Rentmeester"),
  listOf("Nathan", "Miranda"),
  listOf("Nathan", "Wang"),
  listOf("Nathaniel", "Brakeley"),
  listOf("Nathaniel", "Morihara"),
  listOf("Nicole", "Reinhardsen"),
  listOf("Nicole", "Yoblick"),
  listOf("Niko", "Mavrakis"),
  listOf("Nina", "Walker"),
  listOf("Ning", "Cui"),
  listOf("Noah", "Schwartz"),
  listOf("Octavio", "Roscioli"),
  listOf("Oliver", "Castillo"),
  listOf("Oliver", "Scott"),
  listOf("Ori", "Allon"),
  listOf("Ori", "Damary"),
  listOf("Osman", "Ozdemir"),
  listOf("Owen", "Charles"),
  listOf("Ozgur", "Akduran"),
  listOf("Pablo", "Mata"),
  listOf("Paola", "Justiniano"),
  listOf("Parth", "Patel"),
  listOf("Paul", "Brown"),
  listOf("Perry", "Yee"),
  listOf("Peter", "Liang"),
  listOf("Peter", "Liu"),
  listOf("Peter", "Ta"),
  listOf("Preetpal", "Phandar"),
  listOf("Raghav", "Sachdev"),
  listOf("Rahul", "Ratnakar"),
  listOf("Rahul", "Singh"),
  listOf("Raju", "Matta"),
  listOf("Ran", "Ding"),
  listOf("Raquel", "Bujans"),
  listOf("Ray", "Bueno"),
  listOf("Raymond", "Leung"),
  listOf("Raymond", "Wang"),
  listOf("Renato", "Gamboa"),
  listOf("Revathi", "Kandoji"),
  listOf("Rex", "Zhang"),
  listOf("Rich", "Pean"),
  listOf("Rich", "Simon"),
  listOf("Robert", "Gray"),
  listOf("Robert", "Reffkin"),
  listOf("Roger", "Geng"),
  listOf("Roger", "King"),
  listOf("Rohit", "Khanwani"),
  listOf("Rohit", "Kommareddy"),
  listOf("Rolando", "Penate"),
  listOf("Roman", "Blum"),
  listOf("Roman", "Valiouline"),
  listOf("Rong", "Chen"),
  listOf("Ross", "Bierbryer"),
  listOf("Russell", "Kaehler"),
  listOf("Russell", "Stephens"),
  listOf("Ruth", "Reffkin"),
  listOf("Ryan", "D'souza"),
  listOf("Ryan", "Houston"),
  listOf("Sagar", "Vora"),
  listOf("Saket", "Joshi"),
  listOf("Sam", "Lynch"),
  listOf("Sam", "Rowland"),
  listOf("Sam", "Sandoval"),
  listOf("Sam", "Stevens"),
  listOf("Sammy", "Shaar"),
  listOf("Samuel", "Rispaud"),
  listOf("Samuel", "Weiss"),
  listOf("Sana", "Sheikh"),
  listOf("Sarah", "Ahmed"),
  listOf("Sarah", "Jang"),
  listOf("Sarath", "Mantrala"),
  listOf("Sarita", "Goswami"),
  listOf("Satwik", "Seshasai"),
  listOf("Saurabh", "Shah"),
  listOf("Savanna", "Butterworth"),
  listOf("Savio", "Fernandes"),
  listOf("Scott", "Bierbryer"),
  listOf("Scott", "Block"),
  listOf("Scott", "Roepnack"),
  listOf("Sean", "Fitzell"),
  listOf("Sean", "Hallahan"),
  listOf("Sean", "Wheeler"),
  listOf("Shah", "Noor"),
  listOf("Shannon", "Sullivan"),
  listOf("Sharon", "Kapitula"),
  listOf("Sharon", "Kim"),
  listOf("Shauna", "Suthersan"),
  listOf("Shayaan", "Ali"),
  listOf("Shean", "Kim"),
  listOf("Shelley", "Zhong"),
  listOf("Shenzhi", "Li"),
  listOf("Shiloh", "Stuart"),
  listOf("Shirley", "Zhang"),
  listOf("Shiyang", "Fei"),
  listOf("Shiyuan", "Wang"),
  listOf("Siddharth", "Sarasvati"),
  listOf("Simon", "Thomas"),
  listOf("Siyuan", "Zhu"),
  listOf("Smriti", "Mehra"),
  listOf("Sohom", "Bhattacharya"),
  listOf("Stephanie", "Trimboli"),
  listOf("Stephen", "Spyropoulos"),
  listOf("Steve", "Zhu"),
  listOf("Steven", "Cheshire"),
  listOf("Sujit", "Poudel"),
  listOf("Tal", "Amitai"),
  listOf("Tal", "Netanyahu"),
  listOf("Tania", "Goswami"),
  listOf("Tao", "Xie"),
  listOf("Terry", "Zheng"),
  listOf("Theodore", "Rose"),
  listOf("Thomas", "Cardwell"),
  listOf("Thomas", "Hallock"),
  listOf("Thomas", "Tran"),
  listOf("Timothee", "Roussilhe"),
  listOf("Timothy", "Knox"),
  listOf("Todd", "Parmley"),
  listOf("Tong", "Li"),
  listOf("Tony", "Chung"),
  listOf("Tracy", "Miller"),
  listOf("Travis", "Van Belle"),
  listOf("Troy", "Crosby"),
  listOf("Tuan-Chun", "Chen"),
  listOf("Ugo", "DiGirolamo"),
  listOf("Veeru", "Namuduri"),
  listOf("Veronica", "Ray"),
  listOf("Vianna", "Vuong"),
  listOf("Victor", "Zhu"),
  listOf("Vincent", "Vuong"),
  listOf("Vivian", "Wong"),
  listOf("Warren", "Miller"), 
  listOf("Wei", "Su"),
  listOf("Wei", "Wang"),
  listOf("Wen", "Ye"),
  listOf("Wes", "Billman"),
  listOf("Wes", "Vial"),
  listOf("Wes", "Zeng"),
  listOf("Will", "Decker"),
  listOf("William", "Bradley"),
  listOf("William", "Horton"),
  listOf("William", "Macarthur-Stanham"),
  listOf("Willy", "Wang"),
  listOf("Xi", "Lian"),
  listOf("Xianbin", "Wu"),
  listOf("Xiao", "Cui"),
  listOf("Xiaoguang", "Li"),
  listOf("Yang", "Zhang"),
  listOf("Yao", "Ding"),
  listOf("Yaron", "Schoen"),
  listOf("Yi", "Chen"),
  listOf("Ying", "Chen"),
  listOf("Yongjian", "Bi"),
  listOf("Yue", "Bi"),
  listOf("Yuvraj", "Vedvyas"),
  listOf("Yvonne", "Wang"),
  listOf("Zack", "Gao"),
  listOf("Zhenfei", "Tai"),
  listOf("Zhifeng", "Shi"),
  listOf("Zhixiang", "Ren"),
  listOf("Zhongxia", "Zhou"),
  listOf("Zhouqian", "Ma"),
  listOf("Zhuoyuan", "Zhang"),
  listOf("Zi", "Lian"),
  listOf("Zikang", "Yao"),
  listOf("Zoey", "Sun"),
  listOf("Zvi", "Band")
)

class Name {
  static var nameIndex = [String:Name]()
  
  var name: String
  var firsts = [Person]()
  var lasts = [Person]()
  var visited = false
  
  init(name: String) {
    self.name = name
  }

  static fun getName(_ value: String) -> Name {
    if let name = nameIndex[value] {
      return name
    } else {
      let name = Name(name:value)
      nameIndex[value] = name
      return name
    }
  }

  fun firstNames() -> String {
    return lasts.map {$0.first.name}.joined(separator: ", ")
  }

  fun lastNames() -> String {
    return firsts.map {$0.last.name}.joined(separator: ", ")
  }

  fun isMagic() -> Bool {
    return firsts.count > 0 && lasts.count > 0
  }

  fun totalCount() -> Int {
    return firsts.count + lasts.count
  }

  fun countPeople() -> Int {
    var count = 0
    visited = true
    (firsts + lasts).forEach { person in
      if (!person.visited) {
        person.visited = true
        count += 1 +
          person.first.countPeople() +
          person.last.countPeople()
      }
    }
    return count
  } 
}

class Person {
  static var people = [Person]()

  var first: Name
  var last: Name
  var visited = false
  
  init(first: Name, last: Name) {
    self.first = first
    self.last = last
  }
  
  static fun loadPeople(_ nameStrings: [[String]]) {
    nameStrings.forEach {
      let first = Name.getName($0[0])
      let last = Name.getName($0[1])
      let person = Person(first:first, last:last)
      first.firsts.append(person)
      last.lasts.append(person)
      people.append(person)
    }
  }

  fun isMagic() -> Bool {
    return first.lasts.count > 0 && last.firsts.count > 0
  }
}

Person.loadPeople(nameStrings)

var names = Array(Name.nameIndex.values)

print("Top first names:")
names
  .filter { _ in true } // TODO: find top first names
  .sorted { $0.firsts.count > $1.firsts.count }[0...4]
  .forEach { print($0.name, "-", $0.lastNames()) }

print("\nTop last names:")
names
  .filter { _ in true } // TODO: find top last names
  .sorted { $0.lasts.count > $1.lasts.count }[0...4]
  .forEach { print($0.name, "-", $0.firstNames()) }

print("\nMagic names:")
names
  .filter { _ in true } // TODO: find magic names
  .filter { $0.isMagic() }
  .sorted { $0.totalCount() > $1.totalCount() }
  .forEach { print($0.name, "-", $0.firstNames(), "/", $0.lastNames()) }

print("\nMagic people:")
Person.people
  .filter { _ in true } // TODO: find magic people
  .filter { $0.isMagic() }
  .forEach { print($0.first.name, $0.last.name) }

print("\nCluster sizes:")
var clusterSizes = [Int:Int]() // TODO: update clusterSizes
names.forEach { name in
  if !name.visited {
    clusterSizes[name.countPeople(), default: 0] += 1
  }
}

for cluster in Array(clusterSizes.keys).sorted() {
  print("\(cluster): \(clusterSizes[cluster]!)")
}
