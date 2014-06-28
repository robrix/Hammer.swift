//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns whether or not the receiver can parse the empty string.
func nullable<Alphabet : Alphabet>(combinator: Combinator<Alphabet>) -> Bool {
	let nullable: Combinator<Alphabet> -> Bool = fixpoint(false) { recur, combinator in
		switch combinator.language {
		case .Null:
			return true
			
		case let .Alternation(left, right):
			return recur(left) || recur(right)
			
		case let .Concatenation(first, second):
			return recur(first) && recur(second)
			
		case .Repetition:
			return true
			
		case let .Reduction(c, _):
			return recur(c)
			
		default:
			return false
		}
	}
	return nullable(combinator)
}
