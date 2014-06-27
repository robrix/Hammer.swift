//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A combinator over languages, which holds the state used in the derivative of parser combinators.
class Combinator<Alphabet : protocol<Printable, Hashable>> {
	typealias Recur = Combinator<Alphabet>
	let language: Language<Alphabet, Recur>
	
	init(language: Language<Alphabet, Recur>) {
		self.language = language
	}
	
	// impolitely airing my implementation details in public
	
	// fixme: define a new fixpoint() variant which assigns a property instead of memoizing in a dictionary
	let _computeHashValue: Recur -> Int = fixpoint(0) { recur, combinator in
		switch combinator.language {
		case .Empty:
			return 0
			
		case let .Null(parses):
			return parses.reduce(parses.count) { hash, each in hash ^ each.hashValue }
			
			
		case let .Literal(c):
			return Hammer.hashValue(c)
			
			
		case let .Alternation(left, right):
			return "Alternation".hashValue ^ recur(left) ^ recur(right)
			
		case let .Concatenation(first, second):
			return "Concatenation".hashValue ^ recur(first) ^ recur(second)
			
			
		case let .Repetition(language):
			return "Repetition".hashValue ^ recur(language)
			
			
		case let .Reduction(language, _):
			return "Reduction".hashValue ^ recur(language)
		}
	}
}

/// Combinator conforms to Hashable.
extension Combinator : Hashable {
	var hashValue: Int {
		return _computeHashValue(self)
	}
}


/// Combinator conforms to Identifiable.
extension Combinator : Identifiable {
	var identity: ObjectIdentifier { return reflect(self).objectIdentifier! }
}


/// Combinator conforms to Equatable.
extension Combinator : Equatable {}

/// Equality between two combinators.
func == <Alphabet : protocol<Printable, Hashable>> (left: Combinator<Alphabet>, right: Combinator<Alphabet>) -> Bool {
	// fixme: file a radar about the lack of type parameters for anonymous closures, variables, & constants
	let equal: (Combinator<Alphabet>, Combinator<Alphabet>) -> Bool = fixpoint(true) { recur, a, b in
		switch (a.language, b.language) {
		case (.Empty, .Empty):
			return true
			
		case let (.Null(x), .Null(y)) where x == y:
			return true
			
		case let (.Literal(x), .Literal(y)) where x == y:
			return true
			
		case let (.Alternation(l1, r1), .Alternation(l2, r2)):
			return recur(l1, l2) && recur(r1, r2)
			
		case let (.Concatenation(f1, s1), .Concatenation(f2, s2)):
			return recur(f1, f2) && recur(s1, s2)
			
		case let (.Repetition(x), .Repetition(y)):
			return recur(x, y)
			
		case let (.Reduction(x, _), .Reduction(y, _)):
			return recur(x, y)
			
		default:
			return false
		}
	}
	return equal(left, right)
}


extension Combinator {
	class func performTests() {
		let count: Combinator<String> -> Int = fixpoint(0) { recur, combinator in
			var count = 1
			switch combinator.language {
			case let .Alternation(left, right):
				count += recur(left) + recur(right)
				
			case let .Concatenation(first, second):
				count += recur(first) + recur(second)
				
			case let .Repetition(child):
				count += recur(child)
				
			case let .Reduction(child, _):
				count += recur(child)
				
			default:
				break
			}
			return count
		}
		
		let empty: Combinator<String> = Combinator<String>(language: Language<String, Combinator<String>>.Empty)
		assert(count(empty) == 1)
		
		let repetition = Combinator<String>(language: empty.language*)
		assert(count(repetition) == 2)
		
		let concatenation = Combinator<String>(language: empty.language+)
		assert(count(concatenation) == 4)
		
		var cyclic: Combinator<String>!
		cyclic = Combinator<String>(language: empty.language ++ cyclic.language ++ empty.language | empty.language)
		assert(count(cyclic) == 8) // fixme: there’s a bug here in that there are two alternations in the graph, and not just one
	}
}
