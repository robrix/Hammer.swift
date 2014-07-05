//  Copyright (c) 2014 Rob Rix. All rights reserved.

import List
import Set

extension Combinator {
	/// Returns the parse forest of a combinator which is the result of parsing input.
	var parseForest: ParseTree<Alphabet> {
		let parseForest: Combinator<Alphabet> -> ParseTree<Alphabet> = fixpoint(ParseTree.Choice([])) { recur, combinator in
			switch combinator.language {
			case let .Null(x):
				return x
				
			case let .Alternation(x, y):
				return recur(x) + recur(y)
				
			case let .Concatenation(x, y):
				// fixme: this needs to be the cartesian product of recur(x) and recur(y)
				return .Nil
				
			case let .Repetition(x):
				return .Nil
				
			case let .Reduction(x, f):
				// fixme: this needs to map recur(x) by f
				return recur(x)
				
			default:
				return .Nil
			}
		}
		return parseForest(self)
	}
}

struct ParseForestTests : Testable {
	static func _performTests() {
		let parsedX = Combinator(parsed: .Leaf(box("x")))
		let parsedY = Combinator(parsed: .Leaf(box("y")))
		assert((parsedX | parsedY).parseForest == .Choice([.Leaf(box("x")), .Leaf(box("y"))]))
	}
}


/// Returns the cartesian product of \c a and \c b.
//func * <A : Sequence, B : Sequence> (a: A, b: B) -> FlattenMapSequenceView<A, MapSequenceView<B, (A.GeneratorType.Element, B.GeneratorType.Element)>> {
//	return flattenMap(a) { first in
//		return map(b) { second in (first, second) }
//	}
//}
