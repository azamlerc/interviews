#import <Foundation/Foundation.h>
#import <stdio.h>

// Here is a list of the people on our team.

// 1. What are the five most popular first names?

// 2. What are the five most popular last names?

// 3. Which "magic" names occur as both first and last names?

// 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

// 5. People are in a group if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a group of 3 people. Print the number of groups of each size.
  
// 6. Do the results change if you add your name to the list?

// Diagram: https://andrewzc.net/interviews/names.pdf

@interface Name: NSObject

@property NSString *name;
@property NSMutableArray *firsts;
@property NSMutableArray *lasts;
@property bool visited;

+ (Name *) name:(NSString *)name;
+ (Name *) getName:(NSString *)value;
+ (NSMutableArray *) allNames;

- (NSString *) firstNames;
- (NSString *) lastNames;
- (bool) isMagic;
- (int) totalCount;
- (int) countPeople;

@end

@interface Person: NSObject

@property Name *first;
@property Name *last;
@property bool visited;

+ (Person *) personWithFirst:(Name *)first last:(Name *)last;

- (bool) isMagic;

@end

@interface NSArray (FunctionalAdditions)

- (void) each:(void(^)(id object))block;
- (NSArray *) sort:(NSComparator)block;
- (NSArray *) sortByInt:(int(^)(id object))block;
- (NSArray *) map:(id(^)(id object))block;
- (NSArray *) filter:(BOOL(^)(id object))block;
- (NSArray *) reverse;
- (NSArray *) limit:(int)limit;

@end

// get rid of NSLog annoying date strings
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

int main (int argc, const char * argv[]) {
  @autoreleasepool {
    NSArray *nameStrings = @[
      @[@"Aaron", @"Wilson"],
      @[@"Abhishek", @"Sarihan"],
      @[@"Abigail", @"Watson"],
      @[@"Adam", @"Beckerman"],
      @[@"Adam", @"Ochayon"],
      @[@"Adam", @"Perea-Kane"],
      @[@"Aditya", @"Mittal"],
      @[@"Aditya", @"Risbud"],
      @[@"Alan", @"Hu"],
      @[@"Alan", @"Wang"],
      @[@"Alex", @"Gates-Shannon"],
      @[@"Alex", @"Meyers"],
      @[@"Alex", @"Nelson"],
      @[@"Alexander", @"Zaman"],
      @[@"Alexandre", @"Petcherski"],
      @[@"Alexei", @"Isac"],
      @[@"Alexis", @"Moody"],
      @[@"Ali", @"Weaver"],
      @[@"Alice", @"Yoon"],
      @[@"Alissa", @"Mittelberg"],
      @[@"Allen", @"Garzone"],
      @[@"Allison", @"Moore"],
      @[@"Allison", @"Ng"],
      @[@"Amit", @"Wadhera"],
      @[@"Amy", @"Takata"],
      @[@"Andrea", @"Dudla"],
      @[@"Andrew", @"Garrett"],
      @[@"Andrew", @"Whittaker"],
      @[@"Andrew", @"Zamler-Carhart"],
      @[@"Andrey", @"Patrov"],
      @[@"Andris", @"Zvargulis"],
      @[@"Angel", @"Dionisio"],
      @[@"Angelina", @"Lam"],
      @[@"Anna", @"Avrekh"],
      @[@"Anna", @"Lee"],
      @[@"Anthony", @"Escamilla"],
      @[@"Anthony", @"Gonzales"],
      @[@"Anya", @"Tran"],
      @[@"Aparna", @"Parlapalli"],
      @[@"Ashley", @"Murphy"],
      @[@"Ashrit", @"Kamireddi"],
      @[@"Avraham", @"Blaut"],
      @[@"Azfar", @"Aziz"],
      @[@"Bart", @"Karmilowicz"],
      @[@"Basia", @"Mucha"],
      @[@"Bastien", @"Falcou"],
      @[@"Beatrice", @"Mendoza"],
      @[@"Ben", @"Griffin"],
      @[@"Ben", @"Hoyt"],
      @[@"Ben", @"Huang"],
      @[@"Bernie", @"Mulligan"],
      @[@"Bharath", @"Swamy"],
      @[@"Bilal", @"Siddiqui"],
      @[@"Bo", @"Huang"],
      @[@"Bobby", @"Singh"],
      @[@"Boris", @"Veltman"],
      @[@"Brandon", @"Kessler"],
      @[@"Brendan", @"Stafford"],
      @[@"Brian", @"Ha"],
      @[@"Brian", @"Renzenbrink"],
      @[@"Brian", @"Ross"],
      @[@"Brittany", @"Chait"],
      @[@"Cade", @"Cairns"],
      @[@"Calvin", @"Lee"],
      @[@"Cameron", @"Waeland"],
      @[@"Catarina", @"Tsang"],
      @[@"Cevon", @"Carver"],
      @[@"Chang", @"Yu"],
      @[@"Charles", @"Bai"],
      @[@"Charles", @"Bentivenga"],
      @[@"Charles", @"Bunton"],
      @[@"Charles", @"Dannaker"],
      @[@"Chen", @"Huang"],
      @[@"Chester", @"Millisock"],
      @[@"Chi", @"Ho"],
      @[@"Chiyi", @"Wang"],
      @[@"Chloe", @"Drew"],
      @[@"Chloe", @"Powell"],
      @[@"Chong", @"Qiu"],
      @[@"Chris", @"Bejnar"],
      @[@"Chris", @"Ewen"],
      @[@"Chris", @"Lee"],
      @[@"Chris", @"Seltzer"],
      @[@"Chrissy", @"Oliver"],
      @[@"Christina", @"Allen"],
      @[@"Cindy", @"Zhang"],
      @[@"Claire", @"Cipriani"],
      @[@"Cory", @"Perkins"],
      @[@"Daljeet", @"Kukreja"],
      @[@"Dan", @"Clark"],
      @[@"Dan", @"Edenhofer"],
      @[@"Dan", @"McClure"],
      @[@"Dan", @"Raykhlin"],
      @[@"Dana", @"Bruschi"],
      @[@"Dani", @"Dugan"],
      @[@"Dani", @"Medina"],
      @[@"Daniel", @"Epstein"],
      @[@"Daniel", @"Han"],
      @[@"Daniel", @"Sanchez"],
      @[@"Daniel", @"Straus"],
      @[@"Danielle", @"Shwed"],
      @[@"Danny", @"Somekh"],
      @[@"Danylo", @"Shpit"],
      @[@"Dave", @"Barth"],
      @[@"Dave", @"DeSandro"],
      @[@"David", @"Mulatti"],
      @[@"David", @"Shure"],
      @[@"Dean", @"Hunt"],
      @[@"Didi", @"Medina"],
      @[@"Dilip", @"Gajendran"],
      @[@"Ding", @"Zhou"],
      @[@"DiXi", @"Qiao"],
      @[@"Djam", @"Saidmuradov"],
      @[@"Don", @"Hoang"],
      @[@"Donald", @"Gray"],
      @[@"Dorian", @"Manning"],
      @[@"Drew", @"Libin"],
      @[@"Eda", @"Kaplan"],
      @[@"Edward", @"Hu"],
      @[@"Ellie", @"Trulinger"],
      @[@"Emily", @"Ho"],
      @[@"Emma", @"Magaw"],
      @[@"Eric", @"Beltran"],
      @[@"Erin", @"Thwaites"],
      @[@"Etai", @"Plushnick"],
      @[@"Ethan", @"Fuld"],
      @[@"Evan", @"Arbeitman"],
      @[@"Evan", @"Compton"],
      @[@"Evgeny", @"Semenov"],
      @[@"Eyal", @"Maaravi"],
      @[@"Fabian", @"Moya"],
      @[@"Fangbo", @"Yang"],
      @[@"Felix", @"Wei"],
      @[@"Foster", @"Provost"],
      @[@"Freddy", @"Munoz"],
      @[@"Fu", @"Zhou"],
      @[@"Gabor", @"Varga"],
      @[@"Gautam", @"Narula"],
      @[@"Geet", @"Bhanawat"],
      @[@"George", @"Markantonis"],
      @[@"Grant", @"Harper"],
      @[@"Greg", @"Mushen"],
      @[@"Greg", @"Scott"],
      @[@"Griffin", @"Jones"],
      @[@"Hadar", @"Yacobovitz"],
      @[@"Haiyang", @"Si"],
      @[@"Han", @"Chae"],
      @[@"Hao", @"Jiang"],
      @[@"Harel", @"Williams"],
      @[@"HeeMin", @"Kim"],
      @[@"Henry", @"Guo"],
      @[@"Henry", @"Lee"],
      @[@"Henry", @"Warren"],
      @[@"Henry", @"Xu"],
      @[@"Herson", @"Castillo"],
      @[@"Hiram", @"Moncivais"],
      @[@"Hongwei", @"Wang"],
      @[@"Hu", @"Zhou"],
      @[@"Ian", @"Cohan-Shapiro"],
      @[@"Ilya", @"Timofeyev"],
      @[@"Jack", @"Amadeo"],
      @[@"Jack", @"Murphy"],
      @[@"Jackie", @"Lynch"],
      @[@"Jackson", @"Cheek"],
      @[@"Jaclyn", @"Verga"],
      @[@"Jamal", @"Carvalho"],
      @[@"James", @"Chen"],
      @[@"James", @"Manlapid"],
      @[@"Jane", @"Calvin"],
      @[@"Jane", @"Wang"],
      @[@"Jane", @"Wang"],
      @[@"Jared", @"Lindauer"],
      @[@"Jason", @"Byck"],
      @[@"Jason", @"LaCarrubba"],
      @[@"Jason", @"Reid"],
      @[@"Jason", @"Walker-Yung"],
      @[@"Jeffrey", @"Tierney"],
      @[@"Jen", @"Yuan"],
      @[@"Jennifer", @"Cen"],
      @[@"Jeremy", @"Huang"],
      @[@"Jeremy", @"Schwartz"],
      @[@"Jessie", @"Gong"],
      @[@"Jim", @"Li"],
      @[@"Jim", @"Zhan"],
      @[@"Jinbo", @"Zhou"],
      @[@"Joanne", @"Juan"],
      @[@"Joe", @"Woodard"],
      @[@"John", @"Gerhardt"],
      @[@"John", @"Gold"],
      @[@"John", @"Simon"],
      @[@"Jon", @"Fu"],
      @[@"Jonathan", @"Word"],
      @[@"Jonny", @"Mooneyham"],
      @[@"Joseph", @"Galindo"],
      @[@"Joseph", @"Schmitt"],
      @[@"Joseph", @"Sirosh"],
      @[@"Joseph", @"Sortland"],
      @[@"Josh", @"Attenberg"],
      @[@"Josh", @"Burton"],
      @[@"Josh", @"Nili"],
      @[@"Josh", @"Stern"],
      @[@"Juan", @"Ayala"],
      @[@"Julia", @"Poladsky"],
      @[@"Julio", @"Dionisio"],
      @[@"Junqi", @"Liao"],
      @[@"Junyu", @"Tian"],
      @[@"Justin", @"Binns"],
      @[@"Justin", @"Poston"],
      @[@"Kamal", @"Behara"],
      @[@"Kari", @"Oliveira"],
      @[@"Karl", @"Jin"],
      @[@"Karthik", @"Sangam"],
      @[@"Kashyap", @"Dixit"],
      @[@"Kate", @"McNulty"],
      @[@"Katy", @"Hockerman"],
      @[@"Kayla", @"Farrell"],
      @[@"Keith", @"Rose"],
      @[@"Kelly", @"Reed"],
      @[@"Kenneth", @"Bergquist"],
      @[@"Kevin", @"Baijnath"],
      @[@"Kevin", @"Li"],
      @[@"Kevin", @"Liu"],
      @[@"Kevin", @"Reid"],
      @[@"Kevin", @"Wong"],
      @[@"Khadija", @"Ali"],
      @[@"Kim", @"Nguyen"],
      @[@"Kim", @"Nguyen"],
      @[@"Kim", @"Nguyen"],
      @[@"Ksenia", @"Coulter"],
      @[@"Kyle", @"Rocco"],
      @[@"Kyler", @"Cameron"], 
      @[@"Lan", @"Jiang"],
      @[@"Landin", @"King"],
      @[@"Lauren", @"Jones"],
      @[@"Lauren", @"Wood"],
      @[@"Lee", @"Pollard"],
      @[@"Leilah", @"Williams"],
      @[@"Leo", @"Yu"],
      @[@"Lihui", @"Cai"],
      @[@"Lilly", @"Ju"],
      @[@"Lindsay", @"Owen"],
      @[@"Lucas", @"Lain"],
      @[@"Lucas", @"Reis"],
      @[@"Lucy", @"Zhong"],
      @[@"Luigi", @"Kapaj"],
      @[@"Luke", @"Downey"],
      @[@"Luran", @"He"],
      @[@"Lycurgo", @"Vidalakis"],
      @[@"Margie", @"Ruparel"],
      @[@"Mark", @"Humphrey"],
      @[@"Martyna", @"Michalska"],
      @[@"Mary", @"Rabin"],
      @[@"Masha", @"Malygina"],
      @[@"Matt", @"Garza"],
      @[@"Matt", @"Spangler"],
      @[@"Matthew", @"Schoen"],
      @[@"Max", @"Spinner"],
      @[@"Megan", @"Clegg"],
      @[@"Melissa", @"Delgado"],
      @[@"Michael", @"Chen"],
      @[@"Michael", @"Hansen"],
      @[@"Michael", @"Lefco"],
      @[@"Michael", @"Marion"],
      @[@"Michael", @"Niday"],
      @[@"Michael", @"Quinn"],
      @[@"Michael", @"Walters"],
      @[@"Michael", @"Wang"],
      @[@"Michaela", @"Keady"],
      @[@"Michelle", @"Yoon"],
      @[@"Min", @"Zhang"],
      @[@"Miranda", @"Ashley"],
      @[@"Monica", @"Lee"],
      @[@"Moya", @"Farvis"],
      @[@"Naader", @"Khan"],
      @[@"Naomi", @"Robert"],
      @[@"Nate", @"Rentmeester"],
      @[@"Nathan", @"Miranda"],
      @[@"Nathan", @"Wang"],
      @[@"Nathaniel", @"Brakeley"],
      @[@"Nathaniel", @"Morihara"],
      @[@"Nicole", @"Reinhardsen"],
      @[@"Nicole", @"Yoblick"],
      @[@"Niko", @"Mavrakis"],
      @[@"Nina", @"Walker"],
      @[@"Ning", @"Cui"],
      @[@"Noah", @"Schwartz"],
      @[@"Octavio", @"Roscioli"],
      @[@"Oliver", @"Castillo"],
      @[@"Oliver", @"Scott"],
      @[@"Ori", @"Allon"],
      @[@"Ori", @"Damary"],
      @[@"Osman", @"Ozdemir"],
      @[@"Owen", @"Charles"],
      @[@"Ozgur", @"Akduran"],
      @[@"Pablo", @"Mata"],
      @[@"Paola", @"Justiniano"],
      @[@"Parth", @"Patel"],
      @[@"Paul", @"Brown"],
      @[@"Perry", @"Yee"],
      @[@"Peter", @"Liang"],
      @[@"Peter", @"Liu"],
      @[@"Peter", @"Ta"],
      @[@"Preetpal", @"Phandar"],
      @[@"Raghav", @"Sachdev"],
      @[@"Rahul", @"Ratnakar"],
      @[@"Rahul", @"Singh"],
      @[@"Raju", @"Matta"],
      @[@"Ran", @"Ding"],
      @[@"Raquel", @"Bujans"],
      @[@"Ray", @"Bueno"],
      @[@"Raymond", @"Leung"],
      @[@"Raymond", @"Wang"],
      @[@"Renato", @"Gamboa"],
      @[@"Revathi", @"Kandoji"],
      @[@"Rex", @"Zhang"],
      @[@"Rich", @"Pean"],
      @[@"Rich", @"Simon"],
      @[@"Robert", @"Gray"],
      @[@"Robert", @"Reffkin"],
      @[@"Roger", @"Geng"],
      @[@"Roger", @"King"],
      @[@"Rohit", @"Khanwani"],
      @[@"Rohit", @"Kommareddy"],
      @[@"Rolando", @"Penate"],
      @[@"Roman", @"Blum"],
      @[@"Roman", @"Valiouline"],
      @[@"Rong", @"Chen"],
      @[@"Ross", @"Bierbryer"],
      @[@"Russell", @"Kaehler"],
      @[@"Russell", @"Stephens"],
      @[@"Ruth", @"Reffkin"],
      @[@"Ryan", @"D'souza"],
      @[@"Ryan", @"Houston"],
      @[@"Sagar", @"Vora"],
      @[@"Saket", @"Joshi"],
      @[@"Sam", @"Lynch"],
      @[@"Sam", @"Rowland"],
      @[@"Sam", @"Sandoval"],
      @[@"Sam", @"Stevens"],
      @[@"Sammy", @"Shaar"],
      @[@"Samuel", @"Rispaud"],
      @[@"Samuel", @"Weiss"],
      @[@"Sana", @"Sheikh"],
      @[@"Sarah", @"Ahmed"],
      @[@"Sarah", @"Jang"],
      @[@"Sarath", @"Mantrala"],
      @[@"Sarita", @"Goswami"],
      @[@"Satwik", @"Seshasai"],
      @[@"Saurabh", @"Shah"],
      @[@"Savanna", @"Butterworth"],
      @[@"Savio", @"Fernandes"],
      @[@"Scott", @"Bierbryer"],
      @[@"Scott", @"Block"],
      @[@"Scott", @"Roepnack"],
      @[@"Sean", @"Fitzell"],
      @[@"Sean", @"Hallahan"],
      @[@"Sean", @"Wheeler"],
      @[@"Shah", @"Noor"],
      @[@"Shannon", @"Sullivan"],
      @[@"Sharon", @"Kapitula"],
      @[@"Sharon", @"Kim"],
      @[@"Shauna", @"Suthersan"],
      @[@"Shayaan", @"Ali"],
      @[@"Shean", @"Kim"],
      @[@"Shelley", @"Zhong"],
      @[@"Shenzhi", @"Li"],
      @[@"Shiloh", @"Stuart"],
      @[@"Shirley", @"Zhang"],
      @[@"Shiyang", @"Fei"],
      @[@"Shiyuan", @"Wang"],
      @[@"Siddharth", @"Sarasvati"],
      @[@"Simon", @"Thomas"],
      @[@"Siyuan", @"Zhu"],
      @[@"Smriti", @"Mehra"],
      @[@"Sohom", @"Bhattacharya"],
      @[@"Stephanie", @"Trimboli"],
      @[@"Stephen", @"Spyropoulos"],
      @[@"Steve", @"Zhu"],
      @[@"Steven", @"Cheshire"],
      @[@"Sujit", @"Poudel"],
      @[@"Tal", @"Amitai"],
      @[@"Tal", @"Netanyahu"],
      @[@"Tania", @"Goswami"],
      @[@"Tao", @"Xie"],
      @[@"Terry", @"Zheng"],
      @[@"Theodore", @"Rose"],
      @[@"Thomas", @"Cardwell"],
      @[@"Thomas", @"Hallock"],
      @[@"Thomas", @"Tran"],
      @[@"Timothee", @"Roussilhe"],
      @[@"Timothy", @"Knox"],
      @[@"Todd", @"Parmley"],
      @[@"Tong", @"Li"],
      @[@"Tony", @"Chung"],
      @[@"Tracy", @"Miller"],
      @[@"Travis", @"Van Belle"],
      @[@"Troy", @"Crosby"],
      @[@"Tuan-Chun", @"Chen"],
      @[@"Ugo", @"DiGirolamo"],
      @[@"Veeru", @"Namuduri"],
      @[@"Veronica", @"Ray"],
      @[@"Vianna", @"Vuong"],
      @[@"Victor", @"Zhu"],
      @[@"Vincent", @"Vuong"],
      @[@"Vivian", @"Wong"],
      @[@"Warren", @"Miller"], 
      @[@"Wei", @"Su"],
      @[@"Wei", @"Wang"],
      @[@"Wen", @"Ye"],
      @[@"Wes", @"Billman"],
      @[@"Wes", @"Vial"],
      @[@"Wes", @"Zeng"],
      @[@"Will", @"Decker"],
      @[@"William", @"Bradley"],
      @[@"William", @"Horton"],
      @[@"William", @"Macarthur-Stanham"],
      @[@"Willy", @"Wang"],
      @[@"Xi", @"Lian"],
      @[@"Xianbin", @"Wu"],
      @[@"Xiao", @"Cui"],
      @[@"Xiaoguang", @"Li"],
      @[@"Yang", @"Zhang"],
      @[@"Yao", @"Ding"],
      @[@"Yaron", @"Schoen"],
      @[@"Yi", @"Chen"],
      @[@"Ying", @"Chen"],
      @[@"Yongjian", @"Bi"],
      @[@"Yue", @"Bi"],
      @[@"Yuvraj", @"Vedvyas"],
      @[@"Yvonne", @"Wang"],
      @[@"Zack", @"Gao"],
      @[@"Zhenfei", @"Tai"],
      @[@"Zhifeng", @"Shi"],
      @[@"Zhixiang", @"Ren"],
      @[@"Zhongxia", @"Zhou"],
      @[@"Zhouqian", @"Ma"],
      @[@"Zhuoyuan", @"Zhang"],
      @[@"Zi", @"Lian"],
      @[@"Zikang", @"Yao"],
      @[@"Zoey", @"Sun"],
      @[@"Zvi", @"Band"]
    ];

    NSMutableArray *people = [NSMutableArray array];
    
    for (NSArray *firstLast in nameStrings) {
      Name *first = [Name getName: firstLast[0]];
      Name *last = [Name getName: firstLast[1]];
      Person *person = [Person personWithFirst:first last:last];
      [first.firsts addObject: person];
      [last.lasts addObject: person];
      [people addObject: person];
    }

    NSMutableArray *names = [Name allNames];

    NSLog(@"Top first names:");
    [[[[[names filter:^BOOL(Name *name) {
      return YES;
    }] sortByInt:^int(Name *name) {
      return [name.firsts count];
    }] reverse] limit: 5] each:^(Name *name) {
      NSLog(@"%@ - %@", name.name, [name lastNames]);
    }];

    NSLog(@"\nTop last names:");
    [[[[[names filter:^BOOL(Name *name) {
      return YES;
    }] sortByInt:^int(Name *name) {
      return [name.lasts count];
    }] reverse] limit: 5] each:^(Name *name) {
      NSLog(@"%@ - %@", name.name, [name firstNames]);
    }];

    NSLog(@"\nMagic names:");
    [[[[[names filter:^BOOL(Name *name) {
      return YES;
    }] filter:^BOOL(Name *name) {
      return [name isMagic];
    }] sortByInt:^int(Name *name) {
      return [name totalCount];
    }] reverse] each:^(Name *name) {
      NSLog(@"%@ - %@ / %@", name.name, [name firstNames], [name lastNames]);
    }];

    NSLog(@"\nMagic people:");
    [[[people filter:^BOOL(Person *person) {
      return YES;
    }] filter:^BOOL(Person *person) {
      return [person isMagic];
    }] each:^(Person *person) {
      NSLog(@"%@ %@", person.first.name, person.last.name);
    }];

    NSLog(@"\nCluster sizes:");
    NSMutableDictionary *clusterSizes = [NSMutableDictionary dictionary];
    for (Name *name in names) {
      if (!name.visited) {
        NSNumber *size = [NSNumber numberWithInt: [name countPeople]];
        NSNumber *count = [clusterSizes objectForKey: size];
        if (count == nil) {
          count = [NSNumber numberWithInt: 1];
        } else {
          count = [NSNumber numberWithInt: [count intValue] + 1];
        }
        [clusterSizes setObject: count forKey: size];
      }
    }

    NSArray *sizes = [[clusterSizes allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSNumber *cluster in sizes) {
      NSLog(@"%@: %@", cluster, [clusterSizes objectForKey: cluster]);
    }
  }
}

@implementation Name

static NSMutableDictionary *nameIndex;

+ (void) initialize {
  if (self == [Name self]) {
    nameIndex = [NSMutableDictionary dictionary];
  }
}

+ (Name *) name:(NSString *)value {
  Name *name = [[Name alloc] init];
  name.name = value;
  name.firsts = [NSMutableArray array];
  name.lasts = [NSMutableArray array];
  name.visited = NO;
  return name;
}

+ (Name *) getName:(NSString *)value {
  Name *name = nameIndex[value];
  if (name == nil) {
    name = [Name name:value];
    nameIndex[value] = name;
  }
  return name;
}

+ (NSMutableArray *) allNames {
  return [[nameIndex allValues] mutableCopy];
}

- (NSString *) firstNames {
  return [[self.lasts map:^(id person) {
    return ((Person *)person).first.name;
  }] componentsJoinedByString: @", "];
}

- (NSString *) lastNames {
  return [[self.firsts map:^(id person) {
    return ((Person *)person).last.name;
  }] componentsJoinedByString: @", "];
}

- (bool) isMagic {
  return [self.firsts count] > 0 && [self.lasts count] > 0;
}

- (int) totalCount {
  return [self.firsts count] + [self.lasts count];
}

- (int) countPeople {
  int count = 0;
  self.visited = true;
  NSArray *allPeople = [self.firsts arrayByAddingObjectsFromArray: self.lasts];

  for (Person *person in allPeople) {
    if (!person.visited) {
      person.visited = true;
      count += 1 +
        [person.first countPeople] +
        [person.last countPeople];
    }
  }
  return count;
} 

@end

@implementation Person

+ (Person *) personWithFirst:(Name *)first last:(Name *)last {
  Person *person = [[Person alloc] init];
  person.first = first;
  person.last = last;
  person.visited = NO;
  return person;
}
  
- (bool) isMagic {
  return [self.first.lasts count] > 0 && [self.last.firsts count] > 0;
}

@end

@implementation NSArray (FunctinalAdditions)

- (void) each:(void(^)(id object))block {
  for (id object in self) {
    block(object);
  }
}

- (NSArray *) sort:(NSComparator)block {
  return [self sortedArrayUsingComparator:block];
}

- (NSArray *) sortByInt:(int(^)(id object))block {
  return [self sortedArrayUsingComparator:^(id a, id b) {
    return [[NSNumber numberWithInt: block(a)] compare:[NSNumber numberWithInt: block(b)]];
  }];
}

- (NSArray *) map:(id(^)(id object))block {
  NSMutableArray *result = [NSMutableArray array];
  for (id object in self) {
    [result addObject:block(object)];
  }
  return result;
}

- (NSArray *) filter:(BOOL(^)(id object))block {
  NSMutableArray *result = [NSMutableArray array];
  for (id object in self) {
    if (block(object)) {
      [result addObject:object];
    }
  }
  return result;
}

- (NSArray *) reverse {
  return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) limit:(int)limit {
  return [self subarrayWithRange:NSMakeRange(0, limit)];
}

@end