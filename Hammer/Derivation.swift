//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

extension Combinator {
	/// Returns the derivative of \c combinator with respect to \c character.
	///
	/// The derivative is a parser which behaves as tho it had already parsed \c character. I.e. if the original parser accepts \c character, then the new parser will start with a null reduction of \c character. Otherwise, it will be empty.
	func derive(character: Alphabet) -> Recur {
		let derive: (Recur, Alphabet) -> Recur = fixpoint(self, { HashablePair($0, $1) }) { recur, parameters in
			let (combinator, character) = parameters
			switch combinator.language {
			case let .Literal(c) where c == character:
				return Combinator(parsed: ParseTree(leaf: c))
				
			case let .Alternation(x, y):
				return recur(x, character) | recur(y, character)
				
			case let .Concatenation(x, y) where x.value.nullable:
				return recur(x, character) ++ y
					| Combinator(parsed: x.value.parseForest) ++ recur(y, character)
			case let .Concatenation(x, y):
				return recur(x, character) ++ y
				
			case let .Repetition(x):
				return recur(x, character) ++ combinator
				
			case let .Reduction(x, f):
				return recur(x, character) --> f
				
			default:
				return Combinator(.Empty)
			}
		}
		return derive(self, character)
	}
}

struct DerivingTests : Testable {
	static func _performTests() {
		let x = "x"
		let xs = Combinator(literal: x)*
		let xs1 = xs.derive(x).compact()
		let parsed = Combinator(parsed: ParseTree(leaf: x))
		assert(xs1 == parsed ++ xs)
		let xs2 = xs1.derive(x).compact()
		assert(xs2 == parsed ++ parsed ++ xs)
	}
}
