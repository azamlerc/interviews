// Here is a list of the people on our team.

// 1. What are the five most popular first names?

// 2. What are the five most popular last names?

// 3. Which "magic" names occur as both first and last names?

// 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

// 5. People are in a cluster if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a cluster of 3 people. Print the number of clusters of each size.
  
// 6. Do the results change if you add your name to the list?

// Diagram: https://andrewzc.net/interviews/names.pdf

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Solution {
  static String nameStrings[][] = {
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
    {"Zvi", "Band"}
  };
  
  public static void main(String[] args) {
    ArrayList<Person> people = new ArrayList<>();
    ArrayList<Name> names;
    
    // builds the graph network for people and names
    for (int i = 0; i < nameStrings.length; i++) {
      Name first = Name.getName(nameStrings[i][0]);
      Name last = Name.getName(nameStrings[i][1]);
      Person person = new Person(first, last);
      first.firsts.add(person);
      last.lasts.add(person);
      people.add(person);
    }
    names = new ArrayList<Name>(Name.nameIndex.values());

    System.out.println("Top first names:");
    names.stream()
      // .filter((name) -> false) // TODO: find top first names
      .sorted((Name n1, Name n2) -> 
        n2.firsts.size() - n1.firsts.size())
      .limit(5)
      .forEach((name) -> 
        System.out.println(name.name + " - " + name.lastNames()));

    System.out.println("\nTop last names:");
    names.stream()
      // .filter((name) -> false) // TODO: find top last names
      .sorted((Name n1, Name n2) -> 
        n2.lasts.size() - n1.lasts.size())
      .limit(5)
      .forEach((name) -> 
        System.out.println(name.name + " - " + name.firstNames()));
   
    System.out.println("\nMagic names:");
    names.stream()
      // .filter((name) -> false) // TODO: find magic names
      .filter(name -> 
        name.firsts.size() > 0 && name.lasts.size() > 0)
      .sorted((Name n1, Name n2) -> 
        n2.firsts.size() + n2.lasts.size() - 
        n1.firsts.size() - n1.lasts.size())
      .forEach((name) -> 
        System.out.println(name.name + " - " + 
          name.firstNames() + " / " + name.lastNames()));

    System.out.println("\nMagic people:");
    people.stream()
      // .filter((name) -> false) // TODO: find magic people
      .filter(person -> 
        person.first.lasts.size() > 0 && 
        person.last.firsts.size() > 0)
      .forEach((person) -> 
        System.out.println(person.first.name + " " +
                           person.last.name));
    
    System.out.println("\nCluster sizes:");
    HashMap<Integer,Integer> clusterSizes = new HashMap<>();
    // TODO: find cluster sizes
    names.stream()
      .filter(name -> !name.visited)
      .forEach(name -> {
        Integer cluster = name.countName();
        Integer count = clusterSizes.get(cluster);
        if (count == null) count = 0;
        count++;
        clusterSizes.put(cluster, count);
    });
    
    ArrayList<Integer> clusters = new ArrayList<Integer>(clusterSizes.keySet());
    Collections.sort(clusters);
    for (Integer cluster : clusters) {
      System.out.println(cluster + ": " + clusterSizes.get(cluster));
    }
  }
}

class Name {
  static HashMap<String,Name> nameIndex = new HashMap<>();
  
  String name;
  ArrayList<Person> firsts;
  ArrayList<Person> lasts;
  Boolean visited;
  int personCount;
  
  Name(String name) {
    this.name = name;
    this.firsts = new ArrayList<>();
    this.lasts = new ArrayList<>();
    this.visited = false;
  }
  
  static Name getName(String value) {
    Name name = nameIndex.get(value);
    if (name == null) {
      name = new Name(value);
      nameIndex.put(value, name);
    }
    return name;
  }
  
  String firstNames() {
    return this.lasts.stream()
      .map(person -> person.first.name)
      .collect(Collectors.joining(", "));
  }
  
  String lastNames() {
    return this.firsts.stream()
      .map(person -> person.last.name)
      .collect(Collectors.joining(", "));
  }
  
  int countName() {
    this.personCount = 0;
    this.visited = true;
    Stream.of(this.firsts, this.lasts)
      .flatMap(x -> x.stream())
      .filter(person -> !person.visited)
      .forEach(person -> {
        person.visited = true;
        this.personCount += 1 + 
          person.first.countName() + 
          person.last.countName();
      });
    return this.personCount;
  } 
}

class Person {
  Name first;
  Name last;
  Boolean visited;
  
  Person(Name first, Name last) {
    this.first = first;
    this.last = last;
    this.visited = false;
  }
}
