// This program implements the Solitaire encryption algorithm 
// as described in the appendix of the book Cryptonomicon by 
// Neal Stephenson:

// https://www.schneier.com/academic/solitaire/

// Solitaire is a cypher that can be performed using a deck of 
// playing cards. If two people each have a deck of playing 
// cards in the same order, each can generate a keystream that 
// can be used to encypher and decypher a message.

#import <Foundation/Foundation.h>
#import <stdio.h>

// get rid of NSLog annoying date strings
#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

typedef id(^Transform)(id);
typedef id(^Operation)(id, id);

@interface NSArray (Functional)

- (NSString *) join;
- (NSArray *) map:(Transform)block;
- (NSArray *) zip:(NSArray *)objects map:(Operation)block;

@end 

@implementation NSArray (Functional)

- (NSString *) join {
  return [self componentsJoinedByString: @""];
}
  
- (NSArray *) map:(Transform)block {
    NSMutableArray *result = [NSMutableArray array];
    for (id object in self) {
        [result addObject:block(object)];
    }
    return result;
}

- (NSArray *) zip:(NSArray *)objects map:(Operation)block {
    NSMutableArray *result = [NSMutableArray array];
    NSUInteger selfCount = [self count];
    NSUInteger objectsCount = [objects count];
    
    for (NSUInteger i = 0; i < selfCount && i < objectsCount; i++) {
        [result addObject: block([self objectAtIndex:i], 
           [objects objectAtIndex:i])];
    }
    return result;
}

@end

@interface NSString (PontifexString)

- (NSInteger) intCode;
+ (NSString *) charWithInt: (NSInteger) value;
- (NSString *) plus: (NSString *) other;
- (NSString *) minus: (NSString *) other;
- (NSString *) add: (NSString *) other;
- (NSString *) subtract: (NSString *) other;
- (NSArray *) split;
- (NSString *) blocks;

@end

@implementation NSString (PontifexString)

- (NSInteger) intCode {
  return [self characterAtIndex: 0] - 64;
}

+ (NSString *) charWithInt: (NSInteger) value {
  while (value < 1) {
    value += 26;
  }
  value = (value - 1) % 26 + 1;
  return [NSString stringWithFormat:@"%c", (char)value + 64];
}

- (NSString *) plus: (NSString *) other {
  return [NSString charWithInt: [self intCode] + [other intCode]];
}

- (NSString *) minus: (NSString *) other {
  return [NSString charWithInt: [self intCode] - [other intCode]];
}

- (NSString *) add: (NSString *) other {
  return [[[self split] zip: [other split] map: ^(id a, id b) {
    return [a plus: b];
  }] join];
}

- (NSString *) subtract: (NSString *) other {
  return [[[self split] zip: [other split] map: ^(id a, id b) {
    return [a minus: b];
  }] join];
}

- (NSArray *) split {
  NSMutableArray *array = [NSMutableArray array];
  for (int i = 0; i < [self length]; i++) {
    NSString *ch = [self substringWithRange:NSMakeRange(i, 1)];
    [array addObject:ch];
  }
  return array;
}

- (NSString *) blocks {
  NSMutableArray *chunks = [NSMutableArray array];
  for (int i = 0; i < [self length]; i += 5) {
    NSString *word = [self substringWithRange:NSMakeRange(i, 5)];
    [chunks addObject:word];
  }
  return [chunks componentsJoinedByString: @" "];
}

@end

typedef enum Suit : NSUInteger {
  Clubs,
  Diamonds,
  Hearts,
  Spades,
  Joker
} Suit;

@interface Card: NSObject

@property NSInteger rank;
@property Suit suit;

- (NSString *) rankString;
- (NSString *) suitString;
- (NSInteger) number;
- (NSString *) letter;

@end

@implementation Card
  
+ (Card *) cardWithRank: (NSUInteger) rank suit: (Suit) suit {
  Card *card = [[Card alloc] init];
  card.rank = rank;
  card.suit = suit;
  return card;
}

- (NSString *) description {
  return [NSString stringWithFormat: @"%@%@", [self rankString], [self suitString]];
}

- (NSString *) rankString {
  if (self.suit == Joker) {
    return self.rank == 1 ? @"A" : @"B";
  } else {
    switch (self.rank) {
      case 1: return @"A";
      case 11: return @"J";
      case 12: return @"Q";
      case 13: return @"K";
      default: return [NSString stringWithFormat: @"%ld", self.rank];
    }
  }
}

- (NSString *) suitString {
  switch (self.suit) {
    case Clubs: return @"♣️";
    case Diamonds: return @"♦️";
    case Hearts: return @"♥️";
    case Spades: return @"♠️";
    default: return @"🃏";
  }
}

- (NSInteger) number {
  switch (self.suit) {
    case Clubs: return self.rank;
    case Diamonds: return self.rank + 13;
    case Hearts: return self.rank + 26;
    case Spades: return self.rank + 39;
    default: return 53;
  }
}

- (NSString *) letter {
  switch (self.suit) {
    case Clubs:
    case Hearts: return [NSString charWithInt: self.rank];
    case Diamonds:
    case Spades: return [NSString charWithInt: self.rank + 13];
    default: return nil;
  }
}

@end

@interface Deck: NSObject
  
@property NSMutableArray *cards;
@property Card *jokerA;
@property Card *jokerB;

+ (Deck *) deck;
- (NSInteger) indexOfCard: (Card *) card;
- (void) moveCard: (Card *) card downBy: (NSInteger) count;
- (void) cut: (NSInteger) count;
- (void) tripleCutCard1: (Card *) card1 card2: (Card *) card2;

@end

NSRange makeRange(NSUInteger start, NSUInteger end) {
  return NSMakeRange(start, end - start);
}
  
@implementation Deck

+ (Deck *) deck {
  Deck *deck = [[Deck alloc] init];
  deck.cards = [NSMutableArray array];
  
  for (Suit suit = Clubs; suit <= Spades; suit++) {
    for (NSInteger rank = 1; rank <= 13; rank++)
      [deck.cards addObject: [Card cardWithRank: rank suit: suit]];
  }
  
  deck.jokerA = [Card cardWithRank: 1 suit: Joker];
  deck.jokerB = [Card cardWithRank: 2 suit: Joker];
  [deck.cards addObject: deck.jokerA];
  [deck.cards addObject: deck.jokerB];
  
  return deck;
}

- (NSString *) description {
  return [[self.cards map: ^(id card) {
    return [card description];
  }] componentsJoinedByString: @" "];
}

- (NSInteger) indexOfCard: (Card *) card {
  return [self.cards indexOfObject: card];  
}

- (void) moveCard: (Card *) card downBy: (NSInteger) count {
  NSInteger index = [self indexOfCard: card];
  [self.cards removeObjectAtIndex: index];
  NSInteger newIndex = (index + count - 1) % [self.cards count] + 1;
  [self.cards insertObject: card atIndex: newIndex];
}

- (void) cut: (NSInteger) count {
  NSArray *slice1 = [self.cards subarrayWithRange: makeRange(count, 53)];
  NSArray *slice2 = [self.cards subarrayWithRange: makeRange(0, count)];
  NSArray *slice3 = [self.cards subarrayWithRange: makeRange(53, 54)];
  [self.cards removeAllObjects];
  [self.cards addObjectsFromArray: slice1];
  [self.cards addObjectsFromArray: slice2];
  [self.cards addObjectsFromArray: slice3];
}

- (void) tripleCutCard1: (Card *) card1 card2: (Card *) card2 {
  NSInteger index1 = [self indexOfCard: card1];
  NSInteger index2 = [self indexOfCard: card2];
  if (index1 > index2) {
    NSInteger temp = index1;
    index1 = index2;
    index2 = temp;
  }
  NSArray *slice1 = [self.cards subarrayWithRange: makeRange(index2 + 1, 54)];
  NSArray *slice2 = [self.cards subarrayWithRange: makeRange(index1, index2 + 1)];
  NSArray *slice3 = [self.cards subarrayWithRange: makeRange(0, index1)];
  [self.cards removeAllObjects];
  [self.cards addObjectsFromArray: slice1];
  [self.cards addObjectsFromArray: slice2];
  [self.cards addObjectsFromArray: slice3];
}

@end
  
@interface Generator: NSObject

- (NSString *) keystream: (NSInteger) length;
- (NSString *) next;

@end

@implementation Generator: NSObject

- (NSString *) keystream: (NSInteger) length {
    NSMutableString *stream = [NSMutableString string];
    while ([stream length] < length) { 
      [stream appendString: [self next]];
    }
    return [stream substringWithRange: NSMakeRange(0, length)];
}

- (NSString *) next {
  return @"A";  
}

@end

@interface Example: Generator

@end

@implementation Example

- (NSString *) next {
  return @"KDWUPONOWT";  
}

@end

@interface Solitaire: Generator

@property Deck *deck;

- (instancetype) initWithPassphrase: (NSString *) passphrase;
- (void) shuffle;

@end

@implementation Solitaire

- (instancetype) initWithPassphrase: (NSString *) passphrase {
  self = [super init];
  self.deck = [Deck deck];

  if (passphrase != nil) {
    for (NSString *letter in [[passphrase uppercaseString] split]) {
      [self shuffle];
      [self.deck cut: [letter intCode]];
    }
  }

  return self;
}

- (NSString *) next {
  [self shuffle];
  NSInteger number = [[self.deck.cards objectAtIndex: 0] number];
  NSString *letter = [[self.deck.cards objectAtIndex: number] letter];
  return letter = nil ? [self next] : letter;
}

- (void) shuffle {
  [self.deck moveCard: self.deck.jokerA downBy: 1];
  [self.deck moveCard: self.deck.jokerB downBy: 2];
  [self.deck tripleCutCard1: self.deck.jokerA card2: self.deck.jokerB];
  [self.deck cut: [[self.deck.cards objectAtIndex: 53] number]];
}

@end

@interface Crypt: NSObject 

@property Generator *generator;

+ (Crypt *) cryptWithGenerator: (Generator *) generator;
- (NSString *) encrypt: (NSString *) string;
- (NSString *) decrypt: (NSString *) string;
+ (NSString *) encryptable: (NSString *) string;

@end

@implementation Crypt
  
+ (Crypt *) cryptWithGenerator: (Generator *) generator {
  Crypt *crypt = [[Crypt alloc] init];
  crypt.generator = generator;
  return crypt;
}

- (NSString *) encrypt: (NSString *) string {
  string = [Crypt encryptable: string];
  NSString *keystream = [self.generator keystream: [string length]];
  return [string add: keystream];
}

- (NSString *) decrypt: (NSString *) string {
  string = [Crypt encryptable: string];
  NSString *keystream = [self.generator keystream: [string length]];
  return [string subtract: keystream];
}

+ (NSString *) encryptable: (NSString *) string {
  string = [string uppercaseString];
  NSCharacterSet *set = [[NSCharacterSet letterCharacterSet] invertedSet];
  string = [[string componentsSeparatedByCharactersInSet: set] join];
  while ([string length] % 5 > 0) {
    string = [string stringByAppendingString: @"X"];
  }
  return string;
}

@end

typedef Generator *(^GeneratorType)(void);

@interface Test: NSObject

@property NSString *plain;
@property NSString *pretty;
@property NSString *encrypted;
@property GeneratorType generator;

+ (Test *) testWithPlain: (NSString *) plain
                  pretty: (NSString *) pretty
               encrypted: (NSString *) encrypted
               generator: (GeneratorType) generator;
- (void) assert: (NSString *) type 
         actual: (NSString *) actual 
       expected: (NSString *) expected;
- (void) run;

@end

@implementation Test
  
+ (Test *) testWithPlain: (NSString *) plain
                  pretty: (NSString *) pretty
               encrypted: (NSString *) encrypted
               generator: (GeneratorType) generator {
  Test *test = [[Test alloc] init];
  test.plain = plain;
  test.pretty = pretty;
  test.encrypted = encrypted;
  test.generator = generator;
  return test;
}

- (void) assert: (NSString *) type 
         actual: (NSString *) actual 
       expected: (NSString *) expected {
  NSLog(@"%@: %@ (%@)", type, 
    [expected isEqual: actual] ? @"pass" : @"fail",
    [expected isEqual: actual] ? expected : 
      [NSString stringWithFormat: @"%@ / %@", expected, actual]);
}
  
- (void) run {
  Crypt *crypt = [Crypt cryptWithGenerator: self.generator()];
  [self assert: @"pretty " 
        actual: [[Crypt encryptable: self.plain] blocks]
      expected: self.pretty];
  [self assert: @"encrypt"
        actual: [[crypt encrypt: self.plain] blocks]
      expected: self.encrypted];
  crypt = [Crypt cryptWithGenerator: self.generator()];
  [self assert: @"decrypt" 
        actual: [[crypt decrypt: self.encrypted] blocks]
      expected: self.pretty];
}

@end

int main (int argc, const char * argv[])
{
  @autoreleasepool {
    for (Test *test in @[
      [Test testWithPlain: @"Hello!" 
                   pretty: @"HELLO" 
                encrypted: @"IFMMP" 
                generator: ^{ return [[Generator alloc] init]; }],
      [Test testWithPlain: @"Do not use PC!" 
                   pretty: @"DONOT USEPC"
                encrypted: @"OSKJJ JGTMW"
                generator: ^{ return [[Example alloc] init]; }],
      [Test testWithPlain: @"Aaaaaaaaaa!" 
                   pretty: @"AAAAA AAAAA" 
                encrypted: @"EXKYI ZSGEH" 
                generator: ^{ return [[Solitaire alloc] 
                  initWithPassphrase: nil]; }],
      [Test testWithPlain: @"Aaaaaaaaaaaaaaa!" 
                   pretty: @"AAAAA AAAAA AAAAA" 
                encrypted: @"ITHZU JIWGR FARMW" 
                generator: ^{ return [[Solitaire alloc] 
                  initWithPassphrase: @"FOO"]; }],
      [Test testWithPlain: @"Solitaire!" 
                   pretty: @"SOLIT AIREX" 
                encrypted: @"KIRAK SFJAN" 
                generator: ^{ return [[Solitaire alloc] 
                  initWithPassphrase: @"CRYPTONOMICON"]; }]]) {
      [test run];
    }
  }
}
