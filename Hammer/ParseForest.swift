//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

extension Combinator {
	/// Returns the parse forest of a combinator which is the result of parsing input.
	var parseForest: ParseTree<Alphabet> {
		let parseForest: Combinator<Alphabet> -> ParseTree<Alphabet> = fixpoint(ParseTree.Nil) { recur, combinator in
			switch combinator.language {
			case let .Null(x):
				return x
				
			case let .Alternation(x, y):
				return recur(x) + recur(y)
				
			case let .Concatenation(x, y):
				return recur(x) * recur(y)
				
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

public struct ParseForestTests : Testable {
	public static func _performTests() {
		let (x, y) = ("x", "y")
		let (xTree, yTree) = (ParseTree(leaf: x), ParseTree(leaf: y))
		let parsedX = Combinator(parsed: xTree)
		let parsedY = Combinator(parsed: yTree)
		assert((parsedX | parsedY).parseForest == .Choice([xTree, yTree]))
		assert((parsedX ++ parsedY).parseForest == .Branch(box(xTree), box(yTree)))
	}
}
