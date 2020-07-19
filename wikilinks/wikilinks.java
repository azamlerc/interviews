// What happens when you keep following the first link in Wikipedia articles?
// You almost always get back to the articles on Existence or Awareness.

// Visualization: https://andrewzc.net/wikilinks/

// You are given an array of article objects, which are connected in a tree.
// Every artcile has exactly one parent, and zero or more children.

// 1. Find the featured articles, which are the leaf nodes with no children.

// 2. Find the set of root articles by following the parent links of each featured
//    article, until you get to a root article whose parent is already in the chain.

// 3. Call printArticle(0) on each unique root node, taking care to avoid printing
//    any article more than once or getting stuck in an infinite loop.

import java.io.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Article {
  String name;
  Article parent;
  ArrayList<Article> children;
  ArrayList<Article> chain;
  int terminal = 0;
  int maxDepth = 0;
  boolean printed = false;

  Article(String name) {
    this.name = name;
    this.children = new ArrayList<>();
  }

  static ArrayList<Article> loadArticles(String[][] names) {
    HashMap<String,Article> index = new HashMap<>();

    for (int i = 0; i < names.length; i++) {
      String name = names[i][0];
      String link = names[i][1];
      Article article = index.getOrDefault(name, new Article(name));
      Article parent = index.getOrDefault(link, new Article(link));
      index.put(name, article);
      index.put(link, parent);

      article.parent = parent;
      parent.children.add(article);
    }

    return new ArrayList<Article>(index.values());
  }

  static void findChains(ArrayList<Article> articles) {
    articles.stream()
      .filter(article -> article.children.size() == 0)
      .forEach(article -> {
        article.chain = article.findChain(new ArrayList<>());
        int depth = article.chain.size();
        article.chain.stream().forEach((a ->
          a.maxDepth = Math.max(a.maxDepth, depth)));
        });
  }

  ArrayList<Article> findChain(ArrayList<Article> chain) {
    if (chain.contains(this)) {
      chain.get(chain.size() - 1).terminal++;
      return chain;
    }
    chain.add(this);
    return parent.findChain(chain);
  }

  static void printArticles(ArrayList<Article> articles) {
    articles.stream()
      .filter(article -> article.terminal > 0)
      .sorted((a1, a2) -> a2.terminal - a1.terminal)
      .forEach(article -> article.printArticle(0));
  }

  void printArticle(int depth) {
    if (!printed) {
      System.out.println("·".repeat(depth) + name);
      printed = true;
      children.stream()
        .sorted((a1, a2) -> a2.maxDepth - a1.maxDepth)
        .forEach(article -> article.printArticle(depth + 1));
    }
  }
}

class Solution {
  static String names[][] = {
    {"1944 Cuba–Florida hurricane", "Atlantic hurricane"},
    {"1962 Tour de France", "Tour de France"},
    {"1974 White House helicopter incident", "United States Army"},
    {"1979 Benson & Hedges Cup", "Benson & Hedges Cup"},
    {"A Song Flung Up to Heaven", "Maya Angelou"},
    {"Abkhazians", "Northwest Caucasian languages"},
    {"Abrahamic religions", "Semitic people"},
    {"Abstraction", "Rule of inference"},
    {"Academic discipline", "Knowledge"},
    {"Academy Awards", "Film industry"},
    {"Action film", "Film genre"},
    {"Action", "Behavioural sciences"},
    {"Action-adventure game", "Video game genre"},
    {"Administrative divisions of Mexico", "Mexico"},
    {"Adore (Smashing Pumpkins album)", "Alternative rock"},
    {"Aerospace manufacturer", "Company"},
    {"Afroasiatic languages", "Language family"},
    {"Agaric", "Mushroom"},
    {"Aitraaz", "Hindi"},
    {"All Souls (TV series)", "Paranormal television"},
    {"Alternative rock", "Rock music"},
    {"American football", "Team sport"},
    {"American Revolutionary War", "United States"},
    {"Andrew Kehoe", "Bath Charter Township"},
    {"Anglicanism", "Western Christianity"},
    {"Anne Hathaway", "Academy Awards"},
    {"Aomori Prefecture", "Prefectures of Japan"},
    {"Aomori", "Aomori Prefecture"},
    {"Architect", "Occupational licensing"},
    {"Argumentation", "Interdisciplinarity"},
    {"Army general (Kingdom of Yugoslavia)", "Kingdom of Serbia"},
    {"Astronomical object", "Astronomy"},
    {"Astronomy", "Natural science"},
    {"Atlantic hurricane", "Tropical cyclone"},
    {"Australasian Antarctic Expedition", "Douglas Mawson"},
    {"Australia", "Sovereign state"},
    {"Awareness", "Consciousness"},
    {"Baby Driver", "Action film"},
    {"Balkans", "Southeast Europe"},
    {"Ballistics", "Mechanics"},
    {"Banksia speciosa", "Family (biology)"},
    {"Baseball", "Bat-and-ball games"},
    {"Basidiomycota", "Phylum"},
    {"Bat-and-ball games", "Sports field"},
    {"Bath Charter Township", "Charter township"},
    {"Bath School disaster", "Andrew Kehoe"},
    {"Battle of Sluys", "Kingdom of England"},
    {"Battleship", "Warship"},
    {"Behavior", "Action"},
    {"Behavioural sciences", "Organism"},
    {"Belongingness", "Emotion"},
    {"Benson & Hedges Cup", "Limited overs cricket"},
    {"Bilevel rail car", "Structure gauge"},
    {"Biology", "Natural science"},
    {"Black Moshannon State Park", "List of Pennsylvania state parks"},
    {"Black Sea", "Body of water"},
    {"Boat", "Watercraft"},
    {"Body of water", "Water"},
    {"Branches of science", "Science"},
    {"Brigadier general", "Military"},
    {"British colonisation of South Australia", "Edward Gibbon Wakefield"},
    {"British hydrogen bomb programme", "Thermonuclear weapon"},
    {"British Pacific Fleet", "Royal Navy"},
    {"Buoyancy", "Force"},
    {"Burundi", "Landlocked country"},
    {"California State Route 76", "State highway"},
    {"Canis", "Genus"},
    {"Cardinal direction", "Points of the compass"},
    {"Categorization", "Symbol grounding problem"},
    {"Catholic Church", "Christian denomination"},
    {"Catopsbaatar", "Genus"},
    {"Caucasus", "Black Sea"},
    {"Cellulose fiber", "Ether"},
    {"Central Africa", "Subregion"},
    {"Ceremonial counties of England", "England"},
    {"Charter township", "Local government"},
    {"Chemical compound", "Chemical substance"},
    {"Chemical substance", "Matter"},
    {"Chemistry", "Branches of science"},
    {"Chestnuts Long Barrow", "Long barrow"},
    {"Chihuahua", "Administrative divisions of Mexico"},
    {"Christian denomination", "Religion"},
    {"Christianity", "Abrahamic religions"},
    {"Civil and political rights", "Rights"},
    {"Classical antiquity", "History"},
    {"Classical physics", "Physics"},
    {"Claudio Monteverdi", "Composer"},
    {"Cognitive science", "Science"},
    {"Cold War", "Geopolitics"},
    {"Collective identity", "Belongingness"},
    {"Combat", "Violence"},
    {"Communication", "Meaning"},
    {"Community", "Level of analysis"},
    {"Company", "Legal person"},
    {"Competition", "Goal"},
    {"Complex system", "System"},
    {"Composer", "Musician"},
    {"Concept", "Abstraction"},
    {"Conceptual model", "Concept"},
    {"Consciousness", "Awareness"},
    {"Continent", "Landmass"},
    {"Corporation", "Company"},
    {"Counting", "Number"},
    {"Country", "Sovereign state"},
    {"Craig Gragg", "American football"},
    {"Creativity", "Idea"},
    {"Cricket", "Bat-and-ball games"},
    {"Cultural system", "Culture"},
    {"Culture", "Social behavior"},
    {"Curvilinear coordinates", "Geometry"},
    {"Cylinder", "Curvilinear coordinates"},
    {"Demetrius III Eucaerus", "Hellenistic period"},
    {"Democratic Republic of the Congo", "Central Africa"},
    {"Department of Transportation", "Government agency"},
    {"Desire", "Emotion"},
    {"Destroyer escort", "United States Navy"},
    {"Douglas Mawson", "Order of the British Empire"},
    {"Dutch Golden Age painting", "Dutch Golden Age"},
    {"Dutch Golden Age", "History of the Netherlands"},
    {"Earth", "Planet"},
    {"Edward Gibbon Wakefield", "South Australia"},
    {"Electricity", "Physics"},
    {"Electronic game", "Game"},
    {"Electrostatic discharge", "Electricity"},
    {"Emotion", "Biology"},
    {"England", "United Kingdom"},
    {"Entrepreneurship", "Small business"},
    {"Essex", "Ceremonial counties of England"},
    {"Ether", "Organic compound"},
    {"Ethos", "Greek"},
    {"Euclidean vector", "Mathematics"},
    {"Europe", "Continent"},
    {"Existence", "Reality"},
    {"Fact", "Reality"},
    {"Family (biology)", "Taxonomic rank"},
    {"Film genre", "Narrative"},
    {"Film industry", "Filmmaking"},
    {"Filmmaking", "Finance"},
    {"Finance", "Financial capital"},
    {"Financial capital", "Entrepreneurship"},
    {"First Silesian War", "Kingdom of Prussia"},
    {"Force", "Physics"},
    {"Founding Fathers of the United States", "Thirteen Colonies"},
    {"Frank Matcham", "Architect"},
    {"Game", "Play"},
    {"Genre", "Communication"},
    {"Genus", "Taxonomy"},
    {"Geography", "Science"},
    {"Geometry", "Mathematics"},
    {"Geopolitics", "Geography"},
    {"George Washington", "Founding Fathers of the United States"},
    {"Goal", "Idea"},
    {"God of War, Ascension", "Action-adventure game"},
    {"Government agency", "Machinery of government"},
    {"Government", "State"},
    {"Governor of Kentucky", "Kentucky"},
    {"Grammar", "Linguistics"},
    {"Great spotted woodpecker", "Woodpecker"},
    {"Greek", "Indo-European languages"},
    {"Ground warfare", "Combat"},
    {"Harmon Killebrew", "Baseball"},
    {"Hellenistic period", "History of the Mediterranean region"},
    {"High Explosive Research", "Nuclear weapon"},
    {"Highway authority", "Department of Transportation"},
    {"Hindi", "Indo-Aryan languages"},
    {"History of the Mediterranean region", "Mediterranean Sea"},
    {"History of the Netherlands", "River delta"},
    {"History", "Prehistory"},
    {"Home video game console", "Video game"},
    {"Hominini", "Tribe (biology)"},
    {"Honour", "Ethos"},
    {"Hurricane Fred (2015)", "Atlantic hurricane"},
    {"Idea", "Philosophy"},
    {"Indo-Aryan languages", "South Asia"},
    {"Indo-European languages", "Language family"},
    {"Information science", "Categorization"},
    {"Inorganic compound", "Chemical compound"},
    {"Interaction", "Interactivity"},
    {"Interactivity", "Information science"},
    {"Interdisciplinarity", "Academic discipline"},
    {"Intergovernmental organization", "Organization"},
    {"International law", "Nation"},
    {"Island country", "Country"},
    {"James A. Ryder", "Catholic Church"},
    {"Japan", "Island country"},
    {"John C. Butler-class destroyer escort", "Destroyer escort"},
    {"John FitzWalter, 2nd Baron FitzWalter", "Essex"},
    {"Juan Davis Bradburn", "Brigadier general"},
    {"Kentucky", "U.S. state"},
    {"Kingdom of England", "Sovereign state"},
    {"Kingdom of Prussia", "Monarchy"},
    {"Kingdom of Serbia", "Balkans"},
    {"Knowledge", "Fact"},
    {"Lactarius torminosus", "Agaric"},
    {"Land", "Earth"},
    {"Landform", "Planetary body"},
    {"Landlocked country", "Sovereign state"},
    {"Landmass", "Land"},
    {"Language family", "Language"},
    {"Language", "Grammar"},
    {"Law", "System"},
    {"Lead ship", "Ship class"},
    {"Legal person", "Person"},
    {"Leisure", "Time"},
    {"Level of analysis", "Social science"},
    {"Lightning", "Electrostatic discharge"},
    {"Limited overs cricket", "Cricket"},
    {"Linguistics", "Science"},
    {"List of governors of Kentucky", "Governor of Kentucky"},
    {"List of Pennsylvania state parks", "State park"},
    {"List of specialized agencies of the United Nations", "United Nations"},
    {"Local government", "Public administration"},
    {"Logic", "Reason"},
    {"Long barrow", "Western Europe"},
    {"Lythronax", "Genus"},
    {"Macedonia (ancient kingdom)", "Classical antiquity"},
    {"Machinery of government", "Government"},
    {"Marcel Lihau", "Democratic Republic of the Congo"},
    {"Mary van Kleeck", "Social science"},
    {"Mathematical object", "Concept"},
    {"Mathematics", "Quantity"},
    {"Matter", "Classical physics"},
    {"Maya Angelou", "Civil and political rights"},
    {"Meaning", "Linguistics"},
    {"Mechanics", "Physics"},
    {"Mediterranean Sea", "Sea"},
    {"Meinhard Michael Moser", "Mycology"},
    {"Mexico", "North America"},
    {"Military", "War"},
    {"Milorad Petrović", "Army general (Kingdom of Yugoslavia)"},
    {"Monarchy", "Government"},
    {"Motion", "Physics"},
    {"Motivation", "Desire"},
    {"Multinational corporation", "Corporation"},
    {"Mushroom", "Spore"},
    {"Music", "The arts"},
    {"Musical instrument", "Music"},
    {"Musician", "Musical instrument"},
    {"Mycology", "Biology"},
    {"Narrative", "Argumentation"},
    {"Nation", "Community"},
    {"Natural science", "Branches of science"},
    {"Naval ship", "Ship"},
    {"Naval warfare", "Combat"},
    {"Nestor Lakoba", "Abkhazians"},
    {"North America", "Continent"},
    {"Northwest Caucasian languages", "Caucasus"},
    {"Nuclear physics", "Physics"},
    {"Nuclear reaction", "Nuclear physics"},
    {"Nuclear weapon design", "Nuclear weapon"},
    {"Nuclear weapon", "Nuclear reaction"},
    {"Number", "Mathematical object"},
    {"Object of the mind", "Object"},
    {"Object", "Philosophy"},
    {"Occupational licensing", "Regulation"},
    {"Ocean", "Water"},
    {"Omphalotus nidiformis", "Basidiomycota"},
    {"Operation Inmate", "British Pacific Fleet"},
    {"Orbital mechanics", "Ballistics"},
    {"Orbiting body", "Orbital mechanics"},
    {"Order of chivalry", "Order"},
    {"Order of the British Empire", "Order of chivalry"},
    {"Order", "Honour"},
    {"Organic compound", "Chemistry"},
    {"Organism", "Biology"},
    {"Organization", "Legal person"},
    {"Paranormal television", "Genre"},
    {"Park", "Recreation"},
    {"Paul E. Patton", "List of governors of Kentucky"},
    {"Pennsylvania", "U.S. state"},
    {"Person", "Reason"},
    {"Philosophy", "Existence"},
    {"Phylum", "Taxonomic rank"},
    {"Physics", "Natural science"},
    {"Pierre Nkurunziza", "Burundi"},
    {"Pipeline transport", "Transport"},
    {"Planet", "Astronomical object"},
    {"Planetary body", "Orbiting body"},
    {"Play", "Motivation"},
    {"Pod (Breeders album)", "Alternative rock"},
    {"Points of the compass", "Euclidean vector"},
    {"Polity", "Collective identity"},
    {"Popular music", "Music"},
    {"Pre-dreadnought battleship", "Battleship"},
    {"Prefectures of Japan", "Japan"},
    {"Prehistory", "Hominini"},
    {"Public administration", "Public policy"},
    {"Public policy", "Rational choice theory"},
    {"Pulp magazine", "Pulp"},
    {"Pulp", "Cellulose fiber"},
    {"Quantity", "Counting"},
    {"Race stage", "Race"},
    {"Race", "Sport"},
    {"Randall Davidson", "Anglicanism"},
    {"Rational choice theory", "Conceptual model"},
    {"Reality", "Object of the mind"},
    {"Reason", "Consciousness"},
    {"Recreation", "Leisure"},
    {"Region", "Geography"},
    {"Regulation", "Complex system"},
    {"Religion", "Cultural system"},
    {"Rights", "Law"},
    {"River delta", "Landform"},
    {"Rock music", "Popular music"},
    {"Route number", "Highway authority"},
    {"Royal Navy", "United Kingdom"},
    {"Rule of inference", "Logic"},
    {"Russian battleship Peresvet", "Lead ship"},
    {"Samuel J. Randall", "Pennsylvania"},
    {"Samuel Mulledy", "Catholic Church"},
    {"Science", "Knowledge"},
    {"Sea", "Ocean"},
    {"Second Continental Congress", "American Revolutionary War"},
    {"Sega Saturn", "Home video game console"},
    {"Sega", "Multinational corporation"},
    {"Semitic languages", "Afroasiatic languages"},
    {"Semitic people", "Semitic languages"},
    {"Sequence", "Mathematics"},
    {"Series finale", "Television show"},
    {"Ship class", "Ship"},
    {"Ship", "Boat"},
    {"Small business", "Corporation"},
    {"SMS Kaiser Wilhelm der Grosse", "Pre-dreadnought battleship"},
    {"Social behavior", "Behavior"},
    {"Social science", "Branches of science"},
    {"South Asia", "South"},
    {"South Australia", "States and territories of Australia"},
    {"South", "Cardinal direction"},
    {"Southeast Europe", "Europe"},
    {"Sovereign state", "International law"},
    {"SpaceX", "Aerospace manufacturer"},
    {"Spalding War Memorial", "World War I memorials"},
    {"Spore", "Biology"},
    {"Sport", "Competition"},
    {"Sports field", "Sport"},
    {"State highway", "Route number"},
    {"State park", "Park"},
    {"State", "Polity"},
    {"States and territories of Australia", "Australia"},
    {"Storm", "Lightning"},
    {"Structure gauge", "Tunnel"},
    {"Subregion", "Region"},
    {"Superliner", "Bilevel rail car"},
    {"Symbol grounding problem", "Cognitive science"},
    {"System", "Interaction"},
    {"Taxonomic rank", "Taxonomy"},
    {"Taxonomy", "Biology"},
    {"Team sport", "Sport"},
    {"Telecommunication", "Wire"},
    {"Television set", "Television"},
    {"Television show", "Television set"},
    {"Television", "Telecommunication"},
    {"The arts", "Creativity"},
    {"The Goldfinch", "Dutch Golden Age painting"},
    {"The Thrill Book", "Pulp magazine"},
    {"Thermonuclear weapon", "Nuclear weapon design"},
    {"These Are the Voyages...", "Series finale"},
    {"Thirteen Colonies", "United States Declaration of Independence"},
    {"Time", "Sequence"},
    {"Tour de France", "Race stage"},
    {"Transport", "Motion"},
    {"Tribe (biology)", "Taxonomic rank"},
    {"Tropical cyclone", "Storm"},
    {"Tunnel", "Pipeline transport"},
    {"U.S. state", "United States"},
    {"United Kingdom", "Sovereign state"},
    {"United Nations", "Intergovernmental organization"},
    {"United States Army", "Ground warfare"},
    {"United States Declaration of Independence", "Second Continental Congress"},
    {"United States Navy", "Naval warfare"},
    {"United States", "North America"},
    {"Unknown (magazine)", "Pulp magazine"},
    {"USS Oberrender", "John C. Butler-class destroyer escort"},
    {"Video game genre", "Video game"},
    {"Video game", "Electronic game"},
    {"Violence", "World Health Organization"},
    {"War", "State"},
    {"Warship", "Naval ship"},
    {"Water", "Inorganic compound"},
    {"Watercraft", "Buoyancy"},
    {"Waterloo Bay massacre", "British colonisation of South Australia"},
    {"Western Christianity", "Christianity"},
    {"Western Europe", "Europe"},
    {"Wire", "Cylinder"},
    {"Wolf", "Canis"},
    {"Woodpecker", "Family (biology)"},
    {"Worcestershire v Somerset, 1979", "1979 Benson & Hedges Cup"},
    {"World Health Organization", "List of specialized agencies of the United Nations"},
    {"World War I memorials", "World War I"},
    {"World War I", "World war"},
    {"World war", "Cold War"}};

  public static void main(String[] args) {
    ArrayList<Article> articles = Article.loadArticles(names);
    Article.findChains(articles);
    Article.printArticles(articles);
  }
}
