# Here is a list of the people on our team.

# 1. What are the five most popular first names?
 
# 2. What are the five most popular last names?

# 3. Which "magic" names occur as both first and last names?
 
# 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

# 5. People are in a group if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a group of 3 people. Print the number of groups of each size.
   
# 6. Do the results change if you add your name to the list?
 
# Diagram: https://andrewzc.net/interviews/names.pdf

people = [
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
]

defmodule Name do
  def isMagic(name, firstIndex, lastIndex) do
    Map.has_key?(firstIndex, name) && Map.has_key?(lastIndex, name)
  end

  def totalCount(name, firstIndex, lastIndex) do
    length(Map.get(firstIndex, name)) + length(Map.get(lastIndex, name))
  end
  
  def valueString(name, index) do 
    index[name] |> Enum.reverse() |> Enum.join(", ")
  end
  
  def visit(name, firstIndex, lastIndex, visitedNames, visitedPeople) do
    if (name in visitedNames) do
      {0, visitedNames, visitedPeople}
    else
      visitedNames = [name | visitedNames]
      firstNames = Map.get(firstIndex, name, [])
      lastNames = Map.get(lastIndex, name, [])
      count = 0

      {count, visitedNames, visitedPeople} = Enum.reduce(firstNames, {count, visitedNames, visitedPeople}, fn(firstName, {count, visitedNames, visitedPeople}) -> 
        person = [firstName, name]
        {firstCount, visitedNames, visitedPeople} = Person.visit(person, firstIndex, lastIndex, visitedNames, visitedPeople)
        count = count + firstCount
        {count, visitedNames, visitedPeople}
      end)

      {count, visitedNames, visitedPeople} = Enum.reduce(lastNames, {count, visitedNames, visitedPeople}, fn(lastName, {count, visitedNames, visitedPeople}) -> 
        person = [name, lastName]
        {lastCount, visitedNames, visitedPeople} = Person.visit(person, firstIndex, lastIndex, visitedNames, visitedPeople)
        count = count + lastCount
        {count, visitedNames, visitedPeople}
      end)
  
      {count, visitedNames, visitedPeople}
    end  
  end
end

defmodule Person do
  def firstName(person) do 
    Enum.at(person, 0)
  end

  def lastName(person) do 
    Enum.at(person, 1)
  end

  def isMagic(person, firstIndex, lastIndex) do
    Map.has_key?(firstIndex, firstName(person)) && Map.has_key?(lastIndex, lastName(person))
  end

  def visit(person, firstIndex, lastIndex, visitedNames, visitedPeople) do
    if (person in visitedPeople) do
      {0, visitedNames, visitedPeople}
    else
      visitedPeople = [person | visitedPeople]
      
      {firstCount, visitedNames, visitedPeople} = Name.visit(Person.firstName(person), firstIndex, lastIndex, visitedNames, visitedPeople)
      {lastCount, visitedNames, visitedPeople} = Name.visit(Person.lastName(person), firstIndex, lastIndex, visitedNames, visitedPeople)
      
      {1 + firstCount + lastCount, visitedNames, visitedPeople}
    end
  end
end
  
lastIndex = %{} # arrays of last names indexed by first name
firstIndex = %{} # arays of first names indexed by last name

{firstIndex, lastIndex} = Enum.reduce(people, {firstIndex, lastIndex}, fn(person, {firstIndex, lastIndex}) ->
    firstName = Person.firstName(person)
    lastName = Person.lastName(person)
    firstNames = [firstName | Map.get(firstIndex, lastName, [])]
    lastNames = [lastName | Map.get(lastIndex, firstName, [])]
    firstIndex = Map.put(firstIndex, lastName, firstNames)
    lastIndex = Map.put(lastIndex, firstName, lastNames)
    {firstIndex, lastIndex}
end)

firstNames = Map.keys(lastIndex)
lastNames = Map.keys(firstIndex)
allNames = [firstNames | lastNames] |> Enum.uniq()

# 1. Print the five most common first names
IO.puts "Top first names:"
firstNames
  |> Enum.sort(fn(n1, n2) -> length(lastIndex[n1]) > length(lastIndex[n2]) end)
  |> Enum.slice(0..4)
  |> Enum.each(fn(name) -> 
    IO.puts("#{name} - #{Name.valueString(name, lastIndex)}") end)

# 2. Print the five most common last names
IO.puts "\nTop last names:"
lastNames
  |> Enum.sort(fn(n1, n2) -> length(firstIndex[n1]) > length(firstIndex[n2]) end)
  |> Enum.slice(0..4)
  |> Enum.each(fn(name) -> 
    IO.puts("#{name} - #{Name.valueString(name, firstIndex)}") end)

# 3. Print the magic names
IO.puts "\nMagic names:"
allNames
  |> Enum.filter(fn(name) -> Name.isMagic(name, firstIndex, lastIndex) end)
  |> Enum.sort()
  |> Enum.reverse()
  |> Enum.sort(fn(n1, n2) -> 
    Name.totalCount(n1, firstIndex, lastIndex) > Name.totalCount(n2, firstIndex, lastIndex) end)
  |> Enum.each(fn(name) -> 
    IO.puts("#{name} - #{Name.valueString(name, firstIndex)} / #{Name.valueString(name, lastIndex)}") end)

IO.puts "\nMagic people:"
people
  |> Enum.filter(fn(person) -> Person.isMagic(person, firstIndex, lastIndex) end)
  |> Enum.each(fn(person) -> 
    IO.puts("#{Person.firstName(person)} #{Person.lastName(person)}") end)

IO.puts "\nCluster sizes:"
clusterSizes = %{}
visitedNames = []
visitedPeople = []

{clusterSizes, _visitedNames, _visitedPeople} = Enum.reduce(allNames, {clusterSizes, visitedNames, visitedPeople}, fn(name, {clusterSizes, visitedNames, visitedPeople}) ->
  {size, visitedNames, visitedPeople} = Name.visit(name, firstIndex, lastIndex, visitedNames, visitedPeople)
  clusterSizes = Map.put(clusterSizes, size, Map.get(clusterSizes, size, 0) + 1)
  {clusterSizes, visitedNames, visitedPeople}
end)

Enum.each(clusterSizes, fn({size, count}) ->
  if (size > 0) do
    IO.puts "#{size}: #{count}"
  end
end)
