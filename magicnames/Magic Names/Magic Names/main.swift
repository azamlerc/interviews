// Here is a list of the people on our team.

// 1. What are the five most popular first names?

// 2. What are the five most popular last names?

// 3. Which "magic" names occur as both first and last names?

// 4. Which "magic" people have a first name that is someone's last name, and a last name that is someone's first name?

// 5. People are in a group if their names are connected in some way. For example, Landin King, Roger King, and Roger Geng are in a group of 3 people. Print the number of groups of each size.

// 6. Do the results change if you add your name to the list?

// Diagram: https://andrewzc.net/interviews/names.pdf

import Foundation

let minMagic = 1

class Name: Equatable {
    static var nameIndex = [String:Name]()

    var name: String
    var firsts = [Person]()
    var lasts = [Person]()
    var visited = false
    var chain: [Name]?

    init(name: String) {
        self.name = name
    }

    static func getName(_ value: String) -> Name {
        if let name = nameIndex[value] {
            return name
        } else {
            let name = Name(name:value)
            nameIndex[value] = name
            return name
        }
    }

    static func == (lhs: Name, rhs: Name) -> Bool {
        return lhs.name == rhs.name
    }

    func firstNames() -> String {
        return "\(lasts.count)"
        // return lasts.map {$0.first.name}.joined(separator: ", ")
    }

    func lastNames() -> String {
        return "\(firsts.count)"
        // return firsts.map {$0.last.name}.joined(separator: ", ")
    }

    func isMagic() -> Bool {
        return firsts.count >= minMagic && lasts.count >= minMagic
    }

    func totalCount() -> Int {
        return firsts.count + lasts.count
    }

    func countPeople() -> Int {
        var count = 0
        visited = true
        (firsts + lasts).forEach { person in
            if (!person.visited) {
                person.visited = true
                count += 1
                if (person.first != self) {
                    count += person.first.countPeople()
                }
                if (person.last != self) {
                    count += person.last.countPeople()
                }
            }
        }
        return count
    }

    func longestChain(depth: Int) -> [Name] {
        if depth > 30 {
            return []
        }
        if let value = chain {
            return value
        } else {
            if firsts.count > 0 {
                chain = [self] + firsts.map {
                        let longest = $0.last.longestChain(depth: depth + 1)
                        return longest.contains(self) ? [] : longest
                    }.sorted { $0.count > $1.count }[0]
            } else {
                chain = [self]
            }

            return chain!
        }
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

    static func loadPeople(_ nameStrings: [[String]]) {
        nameStrings.forEach {
            let first = Name.getName($0[0])
            let last = Name.getName($0[1])
            let person = Person(first:first, last:last)
            first.firsts.append(person)
            last.lasts.append(person)
            people.append(person)
        }
    }

    func isMagic() -> Bool {
        return first.lasts.count >= minMagic && last.firsts.count >= minMagic
    }

    func totalCount() -> Int {
        return first.firsts.count + last.lasts.count
    }
}

func loadEveryone(path: String) {
    guard let peopleString = try? String(contentsOf: URL.init(fileURLWithPath: path)) else {
        print("Error: Couldn't open people")
        return
    }

    let lines: [String] = peopleString.components(separatedBy: "\n")
    let nameStrings = lines.map { $0.components(separatedBy: "\t") }

    Person.loadPeople(nameStrings)
}

let path = "/Users/andrew/Projects/interviews/magicnames/Magic Names/Magic Names/compass.txt"
// let path = "/Users/andrew/Projects/interviews/magicnames/Magic Names/Magic Names/engineering.txt"
loadEveryone(path: path)

var names = Array(Name.nameIndex.values)

//print("Top first names:")
//names
//    .filter { _ in true } // TODO: find top first names
//    .sorted { $0.firsts.count > $1.firsts.count }[0...4]
//    .forEach { print($0.name, "-", $0.lastNames()) }
//
//print("\nTop last names:")
//names
//    .filter { _ in true } // TODO: find top last names
//    .sorted { $0.lasts.count > $1.lasts.count }[0...4]
//    .forEach { print($0.name, "-", $0.firstNames()) }
//
//print("\nMagic names:")
//names
//    .filter { _ in true } // TODO: find magic names
//    .filter { $0.isMagic() }
//    .sorted { $0.totalCount() > $1.totalCount() }
//    .forEach { print($0.name, "-", $0.lastNames(), "/", $0.firstNames()) }
//
//print("\nMagic people:")
//Person.people
//    .filter { _ in true } // TODO: find magic people
//    .filter { $0.isMagic() }
//    .forEach { print($0.first.name, $0.last.name) }
//
//print("\nSame first and last name:")
//Person.people
//    .filter { $0.first.name == $0.last.name }
//    .forEach { print($0.first.name, $0.last.name) }
//
//print("\nMost connected:")
//Person.people
//    .sorted { $0.totalCount() > $1.totalCount() }[0...9]
//    .forEach { print($0.first.name, $0.last.name, "-", $0.totalCount()) }
//
//print("\nPeople with same name:")
//var fullnames = Set<String>()
//Person.people.forEach { person in
//    let fullname = "\(person.first.name) \(person.last.name)"
//    if fullnames.contains(fullname) {
//        print(fullname)
//    } else {
//        fullnames.insert(fullname)
//    }
//}

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

print("\nLongest chain:")
var chains = [[Name]]()
for _ in 0...9 {
    names.shuffle()
    names.forEach { $0.chain = nil }
    names.forEach { _ = $0.longestChain(depth: 0) }
    names.sorted { $0.chain!.count > $1.chain!.count }
        .filter { $0.lasts.count == 0 }[0...1]
        .forEach { chains.append($0.chain!) }
}

chains
    .sorted { $0.count > $1.count }[0...9]
    .forEach { print( $0.count, "-", $0.map { name in name.name }.joined(separator: " ")) }
