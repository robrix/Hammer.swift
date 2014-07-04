//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

/// Returns the derivative of \c combinator with respect to \c character.
///
/// The derivative is a parser which behaves as tho it had already parsed \c character. I.e. if the original parser accepts \c character, then the new parser will start with a null reduction of \c character. Otherwise, it will be empty.
func derive<Alphabet : Alphabet>(combinator: Combinator<Alphabet>, character: Alphabet) -> Combinator<Alphabet> {
	let derive: (Combinator<Alphabet>, Alphabet) -> Combinator<Alphabet> = fixpoint(combinator, { HashablePair($0, $1) }) { recur, parameters in
		let (combinator, character) = parameters
		switch combinator.language {
		case let .Literal(c) where c == character:
			return Combinator(.Null([c]))
			
		case let .Alternation(x, y):
			return Combinator(.Alternation(delay(recur(x, character)), delay(recur(y, character))))
			
		case let .Concatenation(x, y) where x.forced.nullable:
			return recur(x, character) ++ y | Combinator(parsed: x.forced.parseForest) ++ recur(y, character)
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
	return derive(combinator, character)
}

struct DerivingTests : Testable {
	static func _performTests() {
		let x = "x"
		let xs = Combinator(literal: x)*
		let xs1 = derive(xs, x).compact()
		let parsed = Combinator(parsed: [x])
		assert(xs1 == parsed ++ xs)
		let xs2 = derive(xs1, x).compact()
		assert(xs2 == parsed ++ parsed ++ xs)
	}
}
