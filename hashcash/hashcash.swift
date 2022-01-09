import Foundation

// Algorithm: https://en.wikipedia.org/wiki/Hashcash
// Example: 1:20:1303030600:anni@cypherspace.org::McMybZIhxKXu57jd:ckvi

let email = "anni@cypherspace.org"
let defaultBits = 12
let formatter = DateFormatter()
formatter.dateFormat = "yyMMddHHmm"

func base64(numbers: [UInt8]) -> String {
  var data = Data()
  data.append(contentsOf: numbers)
  return data.base64EncodedString()
}

func base64(number: Int) -> String {
  var numbers: [UInt8] = []
  var n = number
  while n > 0 {
    numbers.append(UInt8(n & 0xff))
    n >>= 8
  }
  return base64(numbers: numbers)
}

func random(bytes: Int) -> String {
  var numbers = [UInt8]()
  for _ in 0..<bytes {
    numbers.append(UInt8.random(in:0..<UInt8.max))
  }
  return base64(numbers:numbers)
}

class Hashcash: NSObject {
  var ver = 1
  var bits = defaultBits
  var date = ""
  var resource = ""
  var ext = ""
  var rand = ""
  var counter = ""

  init(resource: String) {
    self.date = formatter.string(from: Date())
    self.resource = resource
    self.rand = random(bytes:12)
  }

  init?(string: String) {
    let parts = string.components(separatedBy:":")
    if parts.count == 7 {
      self.ver = Int(parts[0]) ?? 0
      self.bits = Int(parts[1]) ?? 0
      self.date = parts[2]
      self.resource = parts[3]
      self.ext = parts[4]
      self.rand = parts[5]
      self.counter = parts[6]
    } else {
      return nil
    }
  }

  func proofOfWork() {
    let firstPart = self.descriptionNoCounter
    let max = 2 << (32 - self.bits - 1)
    for i in 0..<1000000 {
      let counter = base64(number: i)
      let value = "\(firstPart)\(counter)"
      let hash = SHA1.hash(from: value)![0]
      if hash < max {
        self.counter = counter
        return
      }
    }
    print("Did not find hash less than \(max)!")
  }

  static func generate(resource: String) -> String {
    let hashcash = Hashcash(resource: resource)
    hashcash.proofOfWork()
    return hashcash.description
  }
  
  static func validate(string: String, resource: String) -> Bool {
    guard let hashcash = Hashcash(string: string) else {
      print("Couldn't parse string: \(string)")
      return false
    }
    // version is correct
    if hashcash.ver != 1 {
      print("Unknown version: \(hashcash.ver)")
      return false
    }
    // date is valid format
    guard let date = formatter.date(from: hashcash.date) else {
      print("Invalid date: \(hashcash.date)")
      return false
    }
    // date is within one day
    let age = date.timeIntervalSinceNow
    if age > 86400 || age < -86400 {
      print("Timestamp out of range: \(age) seconds")
      return false
    }
    // resource is the same
    if resource != hashcash.resource {
      print("Resource mismatch: \(resource)/\(hashcash.resource)")
      return false
    }
    // random data is correct length
    if hashcash.rand.count < 16 {
      print("Random too short: \(hashcash.rand.count)")
      return false
    }
    // SHA1 hash has correct number of leading zero bits
    let hash = SHA1.hash(from: string)![0]
    let max = 2 << (32 - hashcash.bits - 1)
    if hash > max {
      print("hash \(hash) is greater than max \(max)")
      return false
    }
    return true
  }

  override var description: String {
    return [String(self.ver), String(self.bits), 
      self.date, self.resource, self.ext, self.rand,
      self.counter].joined(separator:":")
  }

  var descriptionNoCounter: String {
    return [String(self.ver), String(self.bits), 
      self.date, self.resource, self.ext, self.rand,
      ""].joined(separator:":")
  }
}

let value = Hashcash.generate(resource: email)
print(value)
if Hashcash.validate(string: value, resource: email) {
  print("Validated")
}

infix operator <<< : BitwiseShiftPrecedence
private func <<< (lhs:UInt32, rhs:UInt32) -> UInt32 {
    return lhs << rhs | lhs >> (32-rhs)
}

public struct SHA1 {
  private static let CHUNKSIZE=80
  private static let h0:UInt32 = 0x67452301
  private static let h1:UInt32 = 0xEFCDAB89
  private static let h2:UInt32 = 0x98BADCFE
  private static let h3:UInt32 = 0x10325476
  private static let h4:UInt32 = 0xC3D2E1F0

  private struct context {
    var h:[UInt32]=[SHA1.h0,SHA1.h1,SHA1.h2,SHA1.h3,SHA1.h4]

    mutating func process(chunk:inout ContiguousArray<UInt32>) {
      for i in 0..<16 {
        chunk[i] = chunk[i].bigEndian
      }
      for i in 16...79 {
        chunk[i] = (chunk[i-3] ^ chunk[i-8] ^ chunk[i-14] ^ chunk[i-16]) <<< 1
      }

      var a,b,c,d,e,f,k,temp:UInt32
      a=h[0]; b=h[1]; c=h[2]; d=h[3]; e=h[4]
      f=0x0; k=0x0

      for i in 0...79 {
        switch i {
        case 0...19:
          f = (b & c) | ((~b) & d)
          k = 0x5A827999
        case 20...39:
          f = b ^ c ^ d
          k = 0x6ED9EBA1
        case 40...59:
          f = (b & c) | (b & d) | (c & d)
          k = 0x8F1BBCDC
        case 60...79:
          f = b ^ c ^ d
          k = 0xCA62C1D6
        default: break
        }
        temp = a <<< 5 &+ f &+ e &+ k &+ chunk[i]
        e = d
        d = c
        c = b <<< 30
        b = a
        a = temp
      }

      h[0] = h[0] &+ a
      h[1] = h[1] &+ b
      h[2] = h[2] &+ c
      h[3] = h[3] &+ d
      h[4] = h[4] &+ e
    }
  }

  private static func process(data: inout Data) -> SHA1.context? {
    var context=SHA1.context()
    var w = ContiguousArray<UInt32>(repeating: 0x00000000, count: CHUNKSIZE)
    let ml=data.count << 3
    var range = 0..<64

    while data.count >= range.upperBound {
      w.withUnsafeMutableBufferPointer{ dest in
        data.copyBytes(to: dest, from: range)
      }
      context.process(chunk: &w)
      range = range.upperBound..<range.upperBound+64
    }

    w = ContiguousArray<UInt32>(repeating: 0x00000000, count: CHUNKSIZE)
    range = range.lowerBound..<data.count
    w.withUnsafeMutableBufferPointer{ dest in
      data.copyBytes(to: dest, from: range)
    }
    let bytetochange=range.count % 4
    let shift = UInt32(bytetochange * 8)
    w[range.count/4] |= 0x80 << shift
    if range.count+1 > 56 {
      context.process(chunk: &w)
      w = ContiguousArray<UInt32>(repeating: 0x00000000, count: CHUNKSIZE)
    }

    w[15] = UInt32(ml).bigEndian
    context.process(chunk: &w)
    return context
  }

  public static func hash(from str:String) -> [Int]? {
    guard var data = str.data(using: .utf8) else { return nil }
    return process(data: &data)?.h.map{Int($0)}
  }
}