// Here is a list of the people on our team.

// 1. What are the five most popular first names?

// 2. What are the five most popular last names?

// 3. Which "magic" names occur as both first and last names?

// 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

// 5. People are in a cluster if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a cluster of 3 people. Print the number of clusters of each size.
  
// 6. Do the results change if you add your name to the list?

// Diagram: https://andrewzc.net/interviews/names.pdf

package main
import "fmt"
import "sort"

var nameIndex map[string]*Name
var people []*Person

func main() {
  nameStrings := [][]string{
    {"Aaron", "Wilson"},
    {"Abhishek", "Sarihan"},
    {"Abigail", "Watson"},
    {"Adam", "Beckerman"},
    {"Adam", "Ochayon"},
    {"Adam", "Perea-Kane"},
    {"Aditya", "Mittal"},
    {"Aditya", "Risbud"},
    {"Alan", "Hu"},
    {"Alan", "Wang"},
    {"Alex", "Gates-Shannon"},
    {"Alex", "Meyers"},
    {"Alex", "Nelson"},
    {"Alexander", "Zaman"},
    {"Alexandre", "Petcherski"},
    {"Alexei", "Isac"},
    {"Alexis", "Moody"},
    {"Ali", "Weaver"},
    {"Alice", "Yoon"},
    {"Alissa", "Mittelberg"},
    {"Allison", "Moore"},
    {"Allison", "Ng"},
    {"Amit", "Wadhera"},
    {"Amy", "Takata"},
    {"Andrea", "Dudla"},
    {"Andrew", "Garrett"},
    {"Andrew", "Whittaker"},
    {"Andrew", "Zamler-Carhart"},
    {"Andrey", "Patrov"},
    {"Andris", "Zvargulis"},
    {"Angel", "Dionisio"},
    {"Angelina", "Lam"},
    {"Anna", "Avrekh"},
    {"Anthony", "Escamilla"},
    {"Anthony", "Gonzales"},
    {"Anya", "Tran"},
    {"Aparna", "Parlapalli"},
    {"Ashrit", "Kamireddi"},
    {"Avraham", "Blaut"},
    {"Azfar", "Aziz"},
    {"Bart", "Karmilowicz"},
    {"Basia", "Mucha"},
    {"Bastien", "Falcou"},
    {"Beatrice", "Mendoza"},
    {"Ben", "Griffin"},
    {"Ben", "Hoyt"},
    {"Ben", "Huang"},
    {"Bernie", "Mulligan"},
    {"Bharath", "Swamy"},
    {"Bilal", "Siddiqui"},
    {"Bo", "Huang"},
    {"Bobby", "Singh"},
    {"Boris", "Veltman"},
    {"Brandon", "Kessler"},
    {"Brendan", "Stafford"},
    {"Brian", "Ha"},
    {"Brian", "Renzenbrink"},
    {"Brian", "Ross"},
    {"Brittany", "Chait"},
    {"Cade", "Cairns"},
    {"Calvin", "Lee"},
    {"Cameron", "Waeland"},
    {"Catarina", "Tsang"},
    {"Cevon", "Carver"},
    {"Chang", "Yu"},
    {"Charles", "Bai"},
    {"Charles", "Bentivenga"},
    {"Charles", "Bunton"},
    {"Charles", "Dannaker"},
    {"Chen", "Huang"},
    {"Chester", "Millisock"},
    {"Chi", "Ho"},
    {"Chiyi", "Wang"},
    {"Chloe", "Drew"},
    {"Chloe", "Powell"},
    {"Chong", "Qiu"},
    {"Chris", "Bejnar"},
    {"Chris", "Ewen"},
    {"Chris", "Lee"},
    {"Chris", "Seltzer"},
    {"Chrissy", "Oliver"},
    {"Cindy", "Zhang"},
    {"Claire", "Cipriani"},
    {"Cory", "Perkins"},
    {"Daljeet", "Kukreja"},
    {"Dan", "Clark"},
    {"Dan", "McClure"},
    {"Dan", "Raykhlin"},
    {"Dana", "Bruschi"},
    {"Daniel", "Epstein"},
    {"Daniel", "Han"},
    {"Daniel", "Sanchez"},
    {"Daniel", "Straus"},
    {"Danielle", "Shwed"},
    {"Danny", "Somekh"},
    {"Danylo", "Shpit"},
    {"Dave", "Barth"},
    {"Dave", "DeSandro"},
    {"David", "Mulatti"},
    {"David", "Shure"},
    {"Dean", "Hunt"},
    {"Dilip", "Gajendran"},
    {"Ding", "Zhou"},
    {"DiXi", "Qiao"},
    {"Djam", "Saidmuradov"},
    {"Don", "Hoang"},
    {"Donald", "Gray"},
    {"Dorian", "Manning"},
    {"Drew", "Libin"},
    {"Eda", "Kaplan"},
    {"Edward", "Hu"},
    {"Ellie", "Trulinger"},
    {"Emily", "Ho"},
    {"Emma", "Magaw"},
    {"Eric", "Beltran"},
    {"Erin", "Thwaites"},
    {"Etai", "Plushnick"},
    {"Ethan", "Fuld"},
    {"Evan", "Arbeitman"},
    {"Evan", "Compton"},
    {"Evgeny", "Semenov"},
    {"Eyal", "Maaravi"},
    {"Fabian", "Moya"},
    {"Fangbo", "Yang"},
    {"Felix", "Wei"},
    {"Foster", "Provost"},
    {"Freddy", "Munoz"},
    {"Fu", "Zhou"},
    {"Gabor", "Varga"},
    {"Gautam", "Narula"},
    {"Geet", "Bhanawat"},
    {"George", "Markantonis"},
    {"Grant", "Harper"},
    {"Greg", "Mushen"},
    {"Griffin", "Jones"},
    {"Hadar", "Yacobovitz"},
    {"Haiyang", "Si"},
    {"Han", "Chae"},
    {"Hao", "Jiang"},
    {"Harel", "Williams"},
    {"HeeMin", "Kim"},
    {"Henry", "Guo"},
    {"Henry", "Lee"},
    {"Henry", "Warren"},
    {"Henry", "Xu"},
    {"Herson", "Castillo"},
    {"Hiram", "Moncivais"},
    {"Hongwei", "Wang"},
    {"Ian", "Cohan-Shapiro"},
    {"Ilya", "Timofeyev"},
    {"Jack", "Murphy"},
    {"Jackie", "Lynch"},
    {"Jackson", "Cheek"},
    {"Jaclyn", "Verga"},
    {"Jamal", "Carvalho"},
    {"James", "Chen"},
    {"James", "Manlapid"},
    {"Jane", "Calvin"},
    {"Jane", "Wang"},
    {"Jane", "Wang"},
    {"Jared", "Lindauer"},
    {"Jason", "Byck"},
    {"Jason", "LaCarrubba"},
    {"Jason", "Reid"},
    {"Jason", "Walker-Yung"},
    {"Jeffrey", "Tierney"},
    {"Jen", "Yuan"},
    {"Jennifer", "Cen"},
    {"Jeremy", "Huang"},
    {"Jeremy", "Schwartz"},
    {"Jessie", "Gong"},
    {"Jim", "Li"},
    {"Jim", "Zhan"},
    {"Jinbo", "Zhou"},
    {"Joanne", "Juan"},
    {"Joe", "Woodard"},
    {"John", "Gerhardt"},
    {"John", "Gold"},
    {"John", "Simon"},
    {"Jon", "Fu"},
    {"Jonathan", "Word"},
    {"Joseph", "Galindo"},
    {"Joseph", "Schmitt"},
    {"Joseph", "Sirosh"},
    {"Joseph", "Sortland"},
    {"Josh", "Attenberg"},
    {"Josh", "Burton"},
    {"Josh", "Nili"},
    {"Josh", "Stern"},
    {"Julia", "Poladsky"},
    {"Julio", "Dionisio"},
    {"Junqi", "Liao"},
    {"Junyu", "Tian"},
    {"Justin", "Binns"},
    {"Justin", "Poston"},
    {"Kamal", "Behara"},
    {"Kari", "Oliveira"},
    {"Karl", "Jin"},
    {"Karthik", "Sangam"},
    {"Kashyap", "Dixit"},
    {"Kate", "McNulty"},
    {"Katy", "Hockerman"},
    {"Kayla", "Farrell"},
    {"Keith", "Rose"},
    {"Kelly", "Reed"},
    {"Kenneth", "Bergquist"},
    {"Kevin", "Baijnath"},
    {"Kevin", "Li"},
    {"Kevin", "Liu"},
    {"Kevin", "Reid"},
    {"Kevin", "Wong"},
    {"Khadija", "Ali"},
    {"Kim", "Nguyen"},
    {"Kim", "Nguyen"},
    {"Kim", "Nguyen"},
    {"Ksenia", "Coulter"},
    {"Kyle", "Rocco"},
    {"Kyler", "Cameron"}, 
    {"Lan", "Jiang"},
    {"Landin", "King"},
    {"Lauren", "Jones"},
    {"Lauren", "Wood"},
    {"Lee", "Pollard"},
    {"Leilah", "Williams"},
    {"Leo", "Yu"},
    {"Lihui", "Cai"},
    {"Lindsay", "Owen"},
    {"Lucas", "Lain"},
    {"Lucas", "Reis"},
    {"Lucy", "Zhong"},
    {"Luigi", "Kapaj"},
    {"Luke", "Downey"},
    {"Luran", "He"},
    {"Lycurgo", "Vidalakis"},
    {"Margie", "Ruparel"},
    {"Mark", "Humphrey"},
    {"Martyna", "Michalska"},
    {"Mary", "Rabin"},
    {"Masha", "Malygina"},
    {"Matt", "Garza"},
    {"Matt", "Spangler"},
    {"Matthew", "Schoen"},
    {"Max", "Spinner"},
    {"Megan", "Clegg"},
    {"Melissa", "Delgado"},
    {"Michael", "Chen"},
    {"Michael", "Hansen"},
    {"Michael", "Lefco"},
    {"Michael", "Marion"},
    {"Michael", "Niday"},
    {"Michael", "Quinn"},
    {"Michael", "Wang"},
    {"Michaela", "Keady"},
    {"Michelle", "Yoon"},
    {"Min", "Zhang"},
    {"Monica", "Lee"},
    {"Moya", "Farvis"},
    {"Naader", "Khan"},
    {"Naomi", "Robert"},
    {"Nate", "Rentmeester"},
    {"Nathan", "Miranda"},
    {"Nathaniel", "Brakeley"},
    {"Nathaniel", "Morihara"},
    {"Nicole", "Reinhardsen"},
    {"Nicole", "Yoblick"},
    {"Niko", "Mavrakis"},
    {"Nina", "Walker"},
    {"Ning", "Cui"},
    {"Noah", "Schwartz"},
    {"Octavio", "Roscioli"},
    {"Oliver", "Castillo"},
    {"Oliver", "Scott"},
    {"Ori", "Damary"},
    {"Osman", "Ozdemir"},
    {"Owen", "Charles"},
    {"Ozgur", "Akduran"},
    {"Pablo", "Mata"},
    {"Paola", "Justiniano"},
    {"Parth", "Patel"},
    {"Paulus", "Joy"},
    {"Perry", "Yee"},
    {"Peter", "Liang"},
    {"Peter", "Liu"},
    {"Peter", "Ta"},
    {"Preetpal", "Phandar"},
    {"Raghav", "Sachdev"},
    {"Rahul", "Singh"},
    {"Rahul", "Ratnakar"},
    {"Raju", "Matta"},
    {"Ran", "Ding"},
    {"Raquel", "Bujans"},
    {"Raymond", "Leung"},
    {"Raymond", "Wang"},
    {"Renato", "Gamboa"},
    {"Revathi", "Kandoji"},
    {"Rex", "Zhang"},
    {"Richard", "Pean"},
    {"Robert", "Gray"},
    {"Robert", "Reffkin"},
    {"Roger", "Geng"},
    {"Roger", "King"},
    {"Rohit", "Khanwani"},
    {"Rohit", "Kommareddy"},
    {"Rolando", "Penate"},
    {"Roman", "Blum"},
    {"Roman", "Valiouline"},
    {"Rong", "Chen"},
    {"Ross", "Bierbryer"},
    {"Russell", "Kaehler"},
    {"Russell", "Stephens"},
    {"Ruth", "Reffkin"},
    {"Ryan", "D'souza"},
    {"Ryan", "Houston"},
    {"Sagar", "Vora"},
    {"Saket", "Joshi"},
    {"Sam", "Lynch"},
    {"Sam", "Rowland"},
    {"Sam", "Sandoval"},
    {"Sam", "Stevens"},
    {"Sammy", "Shaar"},
    {"Samuel", "Rispaud"},
    {"Samuel", "Weiss"},
    {"Sana", "Sheikh"},
    {"Sarah", "Ahmed"},
    {"Sarah", "Jang"},
    {"Sarath", "Mantrala"},
    {"Sarita", "Goswami"},
    {"Satwik", "Seshasai"},
    {"Saurabh", "Shah"},
    {"Savanna", "Butterworth"},
    {"Savio", "Fernandes"},
    {"Scott", "Bierbryer"},
    {"Scott", "Block"},
    {"Scott", "Roepnack"},
    {"Sean", "Fitzell"},
    {"Sean", "Hallahan"},
    {"Sean", "Wheeler"},
    {"Shah", "Noor"},
    {"Shannon", "Sullivan"},
    {"Sharon", "Kapitula"},
    {"Sharon", "Kim"},
    {"Shauna", "Suthersan"},
    {"Shayaan", "Ali"},
    {"Shean", "Kim"},
    {"Shelley", "Zhong"},
    {"Shenzhi", "Li"},
    {"Shirley", "Zhang"},
    {"Shiyang", "Fei"},
    {"Shiyuan", "Wang"},
    {"Siddharth", "Sarasvati"},
    {"Simon", "Thomas"},
    {"Siyuan", "Zhu"},
    {"Smriti", "Mehra"},
    {"Sohom", "Bhattacharya"},
    {"Stephanie", "Trimboli"},
    {"Stephen", "Spyropoulos"},
    {"Steve", "Zhu"},
    {"Steven", "Cheshire"},
    {"Sujit", "Poudel"},
    {"Tal", "Amitai"},
    {"Tal", "Netanyahu"},
    {"Tania", "Goswami"},
    {"Terry", "Zheng"},
    {"Theodore", "Rose"},
    {"Thomas", "Cardwell"},
    {"Thomas", "Hallock"},
    {"Thomas", "Tran"},
    {"Timothee", "Roussilhe"},
    {"Timothy", "Knox"},
    {"Todd", "Parmley"},
    {"Tong", "Li"},
    {"Tony", "Chung"},
    {"Tracy", "Miller"},
    {"Travis", "Van Belle"},
    {"Troy", "Crosby"},
    {"Tuan-Chun", "Chen"},
    {"Ugo", "DiGirolamo"},
    {"Veeru", "Namuduri"},
    {"Veronica", "Ray"},
    {"Vianna", "Vuong"},
    {"Victor", "Zhu"},
    {"Vincent", "Vuong"},
    {"Vivian", "Wong"},
    {"Warren", "Miller"}, 
    {"Wei", "Su"},
    {"Wei", "Wang"},
    {"Wen", "Ye"},
    {"Wes", "Billman"},
    {"Wes", "Vial"},
    {"Wes", "Zeng"},
    {"Will", "Decker"},
    {"William", "Bradley"},
    {"William", "Horton"},
    {"William", "Macarthur-Stanham"},
    {"Willy", "Wang"},
    {"Xi", "Lian"},
    {"Xianbin", "Wu"},
    {"Xiao", "Cui"},
    {"Xiaoguang", "Li"},
    {"Yang", "Zhang"},
    {"Yao", "Ding"},
    {"Yaron", "Schoen"},
    {"Yi", "Chen"},
    {"Ying", "Chen"},
    {"Yongjian", "Bi"},
    {"Yue", "Bi"},
    {"Yuvraj", "Vedvyas"},
    {"Yvonne", "Wang"},
    {"Zack", "Gao"},
    {"Zhenfei", "Tai"},
    {"Zhifeng", "Shi"},
    {"Zhixiang", "Ren"},
    {"Zhongxia", "Zhou"},
    {"Zhouqian", "Ma"},
    {"Zhuoyuan", "Zhang"},
    {"Zikang", "Yao"},
    {"Zvi", "Band"}}

  nameIndex = make(map[string]*Name)
  people = []*Person{}
  
  for _, strings := range nameStrings {
    first := nameIndex[strings[0]]
    last := nameIndex[strings[1]]
    if first == nil {
      first = &Name{value: strings[0]}
      nameIndex[strings[0]] = first
    }
    if last == nil {
      last = &Name{value: strings[1]}
      nameIndex[strings[1]] = last
    }
    person := &Person{first: first, last: last}
    first.firsts = append(first.firsts, person)
    last.lasts = append(last.lasts, person)
    people = append(people, person)
  }
  
  names := []*Name{}
  for _, name := range nameIndex {
    names = append(names, name)
  }
  
  print("\nTop first names:\n");
  firstNames := []*Name{} // TODO: find top first names
  sort.Slice(names, func(i, j int) bool {
    return len(names[i].firsts) > len(names[j].firsts)
  })
  firstNames = names[0:5]
  for _, name := range firstNames {
    print(name.value + " - " + name.FirstNames() + "\n")
  }
  
  print("\nTop last names:\n");
  lastNames := []*Name{} // TODO: find top last names
  sort.Slice(names, func(i, j int) bool {
    return len(names[i].lasts) > len(names[j].lasts)
  })
  lastNames = names[0:5]
  for _, name := range lastNames {
    print(name.value + " - " + name.LastNames() + "\n")
  }

  print("\nMagic names:\n");
  for _, name := range names {
    if name.IsMagic() {
      print(name.value + " - " + 
            name.FirstNames() + "/ " + 
            name.LastNames() + "\n")      
    }
  }

  print("\nMagic people:\n");
  for _, person := range people {
    if person.IsMagic() {
      print(person.first.value + " " + person.last.value + "\n")
    }
  }

  print("\nCluster sizes:\n");
  clusterSizes := make(map[int]int) // TODO: update clusterSizes
  for _, name := range names {
    if !name.visited {
      count := name.CountName()
      clusterSizes[count] = clusterSizes[count] + 1
    }
  }
  for cluster, count := range clusterSizes {
    print(fmt.Sprintf("%d: %d\n", cluster, count))    
  }
}

type Name struct {
  value string
  firsts []*Person
  lasts []*Person
  visited bool
}

type Person struct {
  first *Name
  last *Name
  visited bool
}

func (p *Person) IsMagic() bool {
  // return false // TODO: implement
  return len(p.first.lasts) > 0 && len(p.last.firsts) > 0
}

func (n *Name) IsMagic() bool {
  // return false // TODO: implement
  return len(n.firsts) > 0 && len(n.lasts) > 0
}

func (n *Name) FirstNames() string {
  var result string
  for _, person := range n.firsts {
    result += person.last.value + " "
  }
  return result
}

func (n *Name) LastNames() string {
  var result string
  for _, person := range n.lasts {
    result += person.first.value + " "
  }
  return result
}

func (n *Name) CountName() int {
  count := 0
  n.visited = true
  both := append(n.firsts, n.lasts...)
  for _, person := range both {
    if !person.visited {
      person.visited = true
      count += 1 + 
        person.first.CountName() + 
        person.last.CountName()
    }
  }
  return count
} 
