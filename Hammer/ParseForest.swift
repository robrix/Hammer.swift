//  Copyright (c) 2014 Rob Rix. All rights reserved.

import List
import Set

extension Combinator {
	/// Returns the parse forest of a combinator which is the result of parsing input.
	var parseForest: Set<Alphabet> {
		let parseForest: Combinator<Alphabet> -> Set<Alphabet> = fixpoint(Set()) { recur, combinator in
			switch combinator.language {
			case let .Null(x):
				return x
				
			case let .Alternation(x, y):
				return recur(x) + recur(y)
				
			case let .Concatenation(x, y):
				// fixme: this needs to be the cartesian product of recur(x) and recur(y)
				return Set()
				
			case let .Repetition(x):
				// fixme: how does this even work? List() is not in Alphabet.
				return Set(List())
				
			case let .Reduction(x, f):
				// fixme: this needs to map recur(x) by f
				return recur(x)
				
			default:
				return Set()
			}
		}
		return parseForest(self)
	}
}

struct ParseForestTests : Testable {
	static func _performTests() {
		let parsedX = Combinator(parsed: ["x"])
		let parsedY = Combinator(parsed: ["y"])
		assert((parsedX | parsedY).parseForest == Set(["x", "y"]))
	}
}


/// Returns the cartesian product of \c a and \c b.
//func * <A : Sequence, B : Sequence> (a: A, b: B) -> FlattenMapSequenceView<A, MapSequenceView<B, (A.GeneratorType.Element, B.GeneratorType.Element)>> {
//	return flattenMap(a) { first in
//		return map(b) { second in (first, second) }
//	}
//}
