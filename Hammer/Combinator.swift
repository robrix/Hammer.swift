//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A combinator over languages, which holds the state used in the derivative of parser combinators.
class Combinator<Alphabet : protocol<Printable, Hashable>> {
	typealias Recur = Combinator<Alphabet>
	let language: Language<Alphabet, Recur>
	
	init(language: Language<Alphabet, Recur>) {
		self.language = language
	}
}



/// Combinator conforms to Identifiable.
extension Combinator : Identifiable {
	var identity: ObjectIdentifier { return reflect(self).objectIdentifier! }
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
