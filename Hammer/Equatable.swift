//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

// Combinator conforms to Equatable, but this isn’t explicitly declared due to linker errors.
// cf rdar://17489254

/// Equality between two combinators.
func == <Alphabet : Alphabet> (left: Combinator<Alphabet>, right: Combinator<Alphabet>) -> Bool {
	// fixme: file a radar about the lack of type parameters for anonymous closures, variables, & constants
	let equal: (Combinator<Alphabet>, Combinator<Alphabet>) -> Bool = fixpoint(true) { recur, pair in
		switch (pair.0.language, pair.1.language) {
		case (.Empty, .Empty):
			return true
			
		case let (.Null(x), .Null(y)) where x == y:
			return true
			
		case let (.Literal(x), .Literal(y)) where x == y:
			return true
			
		case let (.Alternation(l1, r1), .Alternation(l2, r2)):
			return recur(l1.value, l2.value) && recur(r1.value, r2.value)
			
		case let (.Concatenation(f1, s1), .Concatenation(f2, s2)):
			return recur(f1.value, f2.value) && recur(s1.value, s2.value)
			
		case let (.Repetition(x), .Repetition(y)):
			return recur(x.value, y.value)
			
		case let (.Reduction(x, _), .Reduction(y, _)):
			return recur(x.value, y.value)
			
		default:
			return false
		}
	}
	return equal(left, right)
}
