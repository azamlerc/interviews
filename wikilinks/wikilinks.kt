// What happens when you keep following the first link in Wikipedia articles?
// You almost always get back to the articles on Existence or Awareness.

// Visualization: https://andrewzc.net/wikilinks/

// You are given an array of article objects, which are connected in a tree.
// Every article has exactly one parent, and zero or more children.

// 1. Find the featured articles, which are the leaf nodes with no children.

// 2. Find the set of root articles by following the parent links of each featured
//    article, until you get to a root article whose parent is already in the chain.

// 3. Call printArticle(0) on each unique root node, taking care to avoid printing
//    any article more than once or getting stuck in an infinite loop.

val articleNames = mapOf(
  "1944 Cuba–Florida hurricane" to "Atlantic hurricane",
  "1962 Tour de France" to "Tour de France",
  "1974 White House helicopter incident" to "United States Army",
  "1979 Benson & Hedges Cup" to "Benson & Hedges Cup",
  "A Song Flung Up to Heaven" to "Maya Angelou",
  "Abkhazians" to "Northwest Caucasian languages",
  "Abrahamic religions" to "Semitic people",
  "Abstraction" to "Rule of inference",
  "Academic discipline" to "Knowledge",
  "Academy Awards" to "Film industry",
  "Action film" to "Film genre",
  "Action" to "Behavioural sciences",
  "Action-adventure game" to "Video game genre",
  "Administrative divisions of Mexico" to "Mexico",
  "Adore (Smashing Pumpkins album)" to "Alternative rock",
  "Aerospace manufacturer" to "Company",
  "Afroasiatic languages" to "Language family",
  "Agaric" to "Mushroom",
  "Aitraaz" to "Hindi",
  "All Souls (TV series)" to "Paranormal television",
  "Alternative rock" to "Rock music",
  "American football" to "Team sport",
  "American Revolutionary War" to "United States",
  "Andrew Kehoe" to "Bath Charter Township",
  "Anglicanism" to "Western Christianity",
  "Anne Hathaway" to "Academy Awards",
  "Aomori Prefecture" to "Prefectures of Japan",
  "Aomori" to "Aomori Prefecture",
  "Architect" to "Occupational licensing",
  "Argumentation" to "Interdisciplinarity",
  "Army general (Kingdom of Yugoslavia)" to "Kingdom of Serbia",
  "Astronomical object" to "Astronomy",
  "Astronomy" to "Natural science",
  "Atlantic hurricane" to "Tropical cyclone",
  "Australasian Antarctic Expedition" to "Douglas Mawson",
  "Australia" to "Sovereign state",
  "Awareness" to "Consciousness",
  "Baby Driver" to "Action film",
  "Balkans" to "Southeast Europe",
  "Ballistics" to "Mechanics",
  "Banksia speciosa" to "Family (biology)",
  "Baseball" to "Bat-and-ball games",
  "Basidiomycota" to "Phylum",
  "Bat-and-ball games" to "Sports field",
  "Bath Charter Township" to "Charter township",
  "Bath School disaster" to "Andrew Kehoe",
  "Battle of Sluys" to "Kingdom of England",
  "Battleship" to "Warship",
  "Behavior" to "Action",
  "Behavioural sciences" to "Organism",
  "Belongingness" to "Emotion",
  "Benson & Hedges Cup" to "Limited overs cricket",
  "Bilevel rail car" to "Structure gauge",
  "Biology" to "Natural science",
  "Black Moshannon State Park" to "List of Pennsylvania state parks",
  "Black Sea" to "Body of water",
  "Boat" to "Watercraft",
  "Body of water" to "Water",
  "Branches of science" to "Science",
  "Brigadier general" to "Military",
  "British colonisation of South Australia" to "Edward Gibbon Wakefield",
  "British hydrogen bomb programme" to "Thermonuclear weapon",
  "British Pacific Fleet" to "Royal Navy",
  "Buoyancy" to "Force",
  "Burundi" to "Landlocked country",
  "California State Route 76" to "State highway",
  "Canis" to "Genus",
  "Cardinal direction" to "Points of the compass",
  "Categorization" to "Symbol grounding problem",
  "Catholic Church" to "Christian denomination",
  "Catopsbaatar" to "Genus",
  "Caucasus" to "Black Sea",
  "Cellulose fiber" to "Ether",
  "Central Africa" to "Subregion",
  "Ceremonial counties of England" to "England",
  "Charter township" to "Local government",
  "Chemical compound" to "Chemical substance",
  "Chemical substance" to "Matter",
  "Chemistry" to "Branches of science",
  "Chestnuts Long Barrow" to "Long barrow",
  "Chihuahua" to "Administrative divisions of Mexico",
  "Christian denomination" to "Religion",
  "Christianity" to "Abrahamic religions",
  "Civil and political rights" to "Rights",
  "Classical antiquity" to "History",
  "Classical physics" to "Physics",
  "Claudio Monteverdi" to "Composer",
  "Cognitive science" to "Science",
  "Cold War" to "Geopolitics",
  "Collective identity" to "Belongingness",
  "Combat" to "Violence",
  "Communication" to "Meaning",
  "Community" to "Level of analysis",
  "Company" to "Legal person",
  "Competition" to "Goal",
  "Complex system" to "System",
  "Composer" to "Musician",
  "Concept" to "Abstraction",
  "Conceptual model" to "Concept",
  "Consciousness" to "Awareness",
  "Continent" to "Landmass",
  "Corporation" to "Company",
  "Counting" to "Number",
  "Country" to "Sovereign state",
  "Craig Gragg" to "American football",
  "Creativity" to "Idea",
  "Cricket" to "Bat-and-ball games",
  "Cultural system" to "Culture",
  "Culture" to "Social behavior",
  "Curvilinear coordinates" to "Geometry",
  "Cylinder" to "Curvilinear coordinates",
  "Demetrius III Eucaerus" to "Hellenistic period",
  "Democratic Republic of the Congo" to "Central Africa",
  "Department of Transportation" to "Government agency",
  "Desire" to "Emotion",
  "Destroyer escort" to "United States Navy",
  "Douglas Mawson" to "Order of the British Empire",
  "Dutch Golden Age painting" to "Dutch Golden Age",
  "Dutch Golden Age" to "History of the Netherlands",
  "Earth" to "Planet",
  "Edward Gibbon Wakefield" to "South Australia",
  "Electricity" to "Physics",
  "Electronic game" to "Game",
  "Electrostatic discharge" to "Electricity",
  "Emotion" to "Biology",
  "England" to "United Kingdom",
  "Entrepreneurship" to "Small business",
  "Essex" to "Ceremonial counties of England",
  "Ether" to "Organic compound",
  "Ethos" to "Greek",
  "Euclidean vector" to "Mathematics",
  "Europe" to "Continent",
  "Existence" to "Reality",
  "Fact" to "Reality",
  "Family (biology)" to "Taxonomic rank",
  "Film genre" to "Narrative",
  "Film industry" to "Filmmaking",
  "Filmmaking" to "Finance",
  "Finance" to "Financial capital",
  "Financial capital" to "Entrepreneurship",
  "First Silesian War" to "Kingdom of Prussia",
  "Force" to "Physics",
  "Founding Fathers of the United States" to "Thirteen Colonies",
  "Frank Matcham" to "Architect",
  "Game" to "Play",
  "Genre" to "Communication",
  "Genus" to "Taxonomy",
  "Geography" to "Science",
  "Geometry" to "Mathematics",
  "Geopolitics" to "Geography",
  "George Washington" to "Founding Fathers of the United States",
  "Goal" to "Idea",
  "God of War to Ascension" to "Action-adventure game",
  "Government agency" to "Machinery of government",
  "Government" to "State",
  "Governor of Kentucky" to "Kentucky",
  "Grammar" to "Linguistics",
  "Great spotted woodpecker" to "Woodpecker",
  "Greek" to "Indo-European languages",
  "Ground warfare" to "Combat",
  "Harmon Killebrew" to "Baseball",
  "Hellenistic period" to "History of the Mediterranean region",
  "High Explosive Research" to "Nuclear weapon",
  "Highway authority" to "Department of Transportation",
  "Hindi" to "Indo-Aryan languages",
  "History of the Mediterranean region" to "Mediterranean Sea",
  "History of the Netherlands" to "River delta",
  "History" to "Prehistory",
  "Home video game console" to "Video game",
  "Hominini" to "Tribe (biology)",
  "Honour" to "Ethos",
  "Hurricane Fred (2015)" to "Atlantic hurricane",
  "Idea" to "Philosophy",
  "Indo-Aryan languages" to "South Asia",
  "Indo-European languages" to "Language family",
  "Information science" to "Categorization",
  "Inorganic compound" to "Chemical compound",
  "Interaction" to "Interactivity",
  "Interactivity" to "Information science",
  "Interdisciplinarity" to "Academic discipline",
  "Intergovernmental organization" to "Organization",
  "International law" to "Nation",
  "Island country" to "Country",
  "James A. Ryder" to "Catholic Church",
  "Japan" to "Island country",
  "John C. Butler-class destroyer escort" to "Destroyer escort",
  "John FitzWalter, 2nd Baron FitzWalter" to "Essex",
  "Juan Davis Bradburn" to "Brigadier general",
  "Kentucky" to "U.S. state",
  "Kingdom of England" to "Sovereign state",
  "Kingdom of Prussia" to "Monarchy",
  "Kingdom of Serbia" to "Balkans",
  "Knowledge" to "Fact",
  "Lactarius torminosus" to "Agaric",
  "Land" to "Earth",
  "Landform" to "Planetary body",
  "Landlocked country" to "Sovereign state",
  "Landmass" to "Land",
  "Language family" to "Language",
  "Language" to "Grammar",
  "Law" to "System",
  "Lead ship" to "Ship class",
  "Legal person" to "Person",
  "Leisure" to "Time",
  "Level of analysis" to "Social science",
  "Lightning" to "Electrostatic discharge",
  "Limited overs cricket" to "Cricket",
  "Linguistics" to "Science",
  "List of governors of Kentucky" to "Governor of Kentucky",
  "List of Pennsylvania state parks" to "State park",
  "List of specialized agencies of the United Nations" to "United Nations",
  "Local government" to "Public administration",
  "Logic" to "Reason",
  "Long barrow" to "Western Europe",
  "Lythronax" to "Genus",
  "Macedonia (ancient kingdom)" to "Classical antiquity",
  "Machinery of government" to "Government",
  "Marcel Lihau" to "Democratic Republic of the Congo",
  "Mary van Kleeck" to "Social science",
  "Mathematical object" to "Concept",
  "Mathematics" to "Quantity",
  "Matter" to "Classical physics",
  "Maya Angelou" to "Civil and political rights",
  "Meaning" to "Linguistics",
  "Mechanics" to "Physics",
  "Mediterranean Sea" to "Sea",
  "Meinhard Michael Moser" to "Mycology",
  "Mexico" to "North America",
  "Military" to "War",
  "Milorad Petrović" to "Army general (Kingdom of Yugoslavia)",
  "Monarchy" to "Government",
  "Motion" to "Physics",
  "Motivation" to "Desire",
  "Multinational corporation" to "Corporation",
  "Mushroom" to "Spore",
  "Music" to "The arts",
  "Musical instrument" to "Music",
  "Musician" to "Musical instrument",
  "Mycology" to "Biology",
  "Narrative" to "Argumentation",
  "Nation" to "Community",
  "Natural science" to "Branches of science",
  "Naval ship" to "Ship",
  "Naval warfare" to "Combat",
  "Nestor Lakoba" to "Abkhazians",
  "North America" to "Continent",
  "Northwest Caucasian languages" to "Caucasus",
  "Nuclear physics" to "Physics",
  "Nuclear reaction" to "Nuclear physics",
  "Nuclear weapon design" to "Nuclear weapon",
  "Nuclear weapon" to "Nuclear reaction",
  "Number" to "Mathematical object",
  "Object of the mind" to "Object",
  "Object" to "Philosophy",
  "Occupational licensing" to "Regulation",
  "Ocean" to "Water",
  "Omphalotus nidiformis" to "Basidiomycota",
  "Operation Inmate" to "British Pacific Fleet",
  "Orbital mechanics" to "Ballistics",
  "Orbiting body" to "Orbital mechanics",
  "Order of chivalry" to "Order",
  "Order of the British Empire" to "Order of chivalry",
  "Order" to "Honour",
  "Organic compound" to "Chemistry",
  "Organism" to "Biology",
  "Organization" to "Legal person",
  "Paranormal television" to "Genre",
  "Park" to "Recreation",
  "Paul E. Patton" to "List of governors of Kentucky",
  "Pennsylvania" to "U.S. state",
  "Person" to "Reason",
  "Philosophy" to "Existence",
  "Phylum" to "Taxonomic rank",
  "Physics" to "Natural science",
  "Pierre Nkurunziza" to "Burundi",
  "Pipeline transport" to "Transport",
  "Planet" to "Astronomical object",
  "Planetary body" to "Orbiting body",
  "Play" to "Motivation",
  "Pod (Breeders album)" to "Alternative rock",
  "Points of the compass" to "Euclidean vector",
  "Polity" to "Collective identity",
  "Popular music" to "Music",
  "Pre-dreadnought battleship" to "Battleship",
  "Prefectures of Japan" to "Japan",
  "Prehistory" to "Hominini",
  "Public administration" to "Public policy",
  "Public policy" to "Rational choice theory",
  "Pulp magazine" to "Pulp",
  "Pulp" to "Cellulose fiber",
  "Quantity" to "Counting",
  "Race stage" to "Race",
  "Race" to "Sport",
  "Randall Davidson" to "Anglicanism",
  "Rational choice theory" to "Conceptual model",
  "Reality" to "Object of the mind",
  "Reason" to "Consciousness",
  "Recreation" to "Leisure",
  "Region" to "Geography",
  "Regulation" to "Complex system",
  "Religion" to "Cultural system",
  "Rights" to "Law",
  "River delta" to "Landform",
  "Rock music" to "Popular music",
  "Route number" to "Highway authority",
  "Royal Navy" to "United Kingdom",
  "Rule of inference" to "Logic",
  "Russian battleship Peresvet" to "Lead ship",
  "Samuel J. Randall" to "Pennsylvania",
  "Samuel Mulledy" to "Catholic Church",
  "Science" to "Knowledge",
  "Sea" to "Ocean",
  "Second Continental Congress" to "American Revolutionary War",
  "Sega Saturn" to "Home video game console",
  "Sega" to "Multinational corporation",
  "Semitic languages" to "Afroasiatic languages",
  "Semitic people" to "Semitic languages",
  "Sequence" to "Mathematics",
  "Series finale" to "Television show",
  "Ship class" to "Ship",
  "Ship" to "Boat",
  "Small business" to "Corporation",
  "SMS Kaiser Wilhelm der Grosse" to "Pre-dreadnought battleship",
  "Social behavior" to "Behavior",
  "Social science" to "Branches of science",
  "South Asia" to "South",
  "South Australia" to "States and territories of Australia",
  "South" to "Cardinal direction",
  "Southeast Europe" to "Europe",
  "Sovereign state" to "International law",
  "SpaceX" to "Aerospace manufacturer",
  "Spalding War Memorial" to "World War I memorials",
  "Spore" to "Biology",
  "Sport" to "Competition",
  "Sports field" to "Sport",
  "State highway" to "Route number",
  "State park" to "Park",
  "State" to "Polity",
  "States and territories of Australia" to "Australia",
  "Storm" to "Lightning",
  "Structure gauge" to "Tunnel",
  "Subregion" to "Region",
  "Superliner" to "Bilevel rail car",
  "Symbol grounding problem" to "Cognitive science",
  "System" to "Interaction",
  "Taxonomic rank" to "Taxonomy",
  "Taxonomy" to "Biology",
  "Team sport" to "Sport",
  "Telecommunication" to "Wire",
  "Television set" to "Television",
  "Television show" to "Television set",
  "Television" to "Telecommunication",
  "The arts" to "Creativity",
  "The Goldfinch" to "Dutch Golden Age painting",
  "The Thrill Book" to "Pulp magazine",
  "Thermonuclear weapon" to "Nuclear weapon design",
  "These Are the Voyages..." to "Series finale",
  "Thirteen Colonies" to "United States Declaration of Independence",
  "Time" to "Sequence",
  "Tour de France" to "Race stage",
  "Transport" to "Motion",
  "Tribe (biology)" to "Taxonomic rank",
  "Tropical cyclone" to "Storm",
  "Tunnel" to "Pipeline transport",
  "U.S. state" to "United States",
  "United Kingdom" to "Sovereign state",
  "United Nations" to "Intergovernmental organization",
  "United States Army" to "Ground warfare",
  "United States Declaration of Independence" to "Second Continental Congress",
  "United States Navy" to "Naval warfare",
  "United States" to "North America",
  "Unknown (magazine)" to "Pulp magazine",
  "USS Oberrender" to "John C. Butler-class destroyer escort",
  "Video game genre" to "Video game",
  "Video game" to "Electronic game",
  "Violence" to "World Health Organization",
  "War" to "State",
  "Warship" to "Naval ship",
  "Water" to "Inorganic compound",
  "Watercraft" to "Buoyancy",
  "Waterloo Bay massacre" to "British colonisation of South Australia",
  "Western Christianity" to "Christianity",
  "Western Europe" to "Europe",
  "Wire" to "Cylinder",
  "Wolf" to "Canis",
  "Woodpecker" to "Family (biology)",
  "Worcestershire v Somerset, 1979" to "1979 Benson & Hedges Cup",
  "World Health Organization" to "List of specialized agencies of the United Nations",
  "World War I memorials" to "World War I",
  "World War I" to "World war",
  "World war" to "Cold War")

class Article(name: String) {
  var name = name
  var parent: Article? = null
  var children = mutableListOf<Article>()
  var chain = mutableListOf<Article>()
  var terminal = 0
  var maxDepth = 0
  var printed = false

  fun printArticle(depth: Int) {
    if (!printed) {
      println("·".repeat(depth) + name)
      printed = true
      children
        .sortedBy { it.maxDepth }
        .reversed()
        .forEach { it.printArticle(depth + 1) }
    }
  }
  
  fun findChain(chain: MutableList<Article>): MutableList<Article> {
    if (chain.contains(this)) {
      chain.last().terminal += 1
      return chain
    }
    var newChain = chain
    newChain.add(this)
    return parent!!.findChain(newChain)
  }
}

var articleIndex = mutableMapOf<String,Article>()
  
fun getArticle(name: String): Article {
  var article = articleIndex.get(name)
  if (article != null) {
    return article
  } else {
    article = Article(name)
    articleIndex.put(name, article)
    return article
  }
}

fun loadArticles(names: Map<String,String>): List<Article> {
  for ((name, link) in names) {
    var article = getArticle(name)
    var parent = getArticle(link)
    articleIndex[name] = article
    articleIndex[link] = parent

    article.parent = parent
    parent.children.add(article)
  }

  return articleIndex.values.toMutableList()
}

fun findChains(articles: List<Article>) {
  articles
    .filter { it.children.size == 0 }
    .forEach { article ->
      article.chain = article.findChain(mutableListOf<Article>())
      var depth = article.chain.size
      article.chain.forEach {
        it.maxDepth = maxOf(it.maxDepth, depth)
      }
  }
}

fun printArticles(articles: List<Article>) {
  articles
    .filter { it.terminal > 0 }
    .sortedBy { it.terminal }
    .forEach { it.printArticle(0) }
}

fun main(args: Array<String>) {
  var articles = loadArticles(articleNames)
  // articles[101].printArticle(0)
  
  findChains(articles)
  printArticles(articles)
}
