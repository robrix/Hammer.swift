//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A combinator over languages, which holds the state used in the derivative of parser combinators.
@final class Combinator<Alphabet : Alphabet> {
	typealias Recur = Combinator<Alphabet>
	let language: Language<Alphabet, Recur>
	
	init(_ language: Language<Alphabet, Recur>) {
		self.language = language
	}
}


extension Combinator : Testable {
	class func _performTests() {
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
		
		let empty = Combinator<String>(.Empty)
		assert(count(empty) == 1)
		
		let repetition = empty*
		assert(count(repetition) == 2)
		
		let concatenation = empty+
		assert(count(concatenation) == 4)
		
		var cyclic: Combinator<String>!
		cyclic = empty ++ cyclic ++ empty | empty
		assert(count(cyclic) == 6)
	}
}
