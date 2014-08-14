//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Combinator {
	/// Returns whether or not the receiver can parse the empty string.
	var nullable: Bool {
		let nullable: Combinator<Alphabet> -> Bool = fixpoint(false) { recur, combinator in
			switch combinator.language {
			case .Null:
				return true
				
			case let .Alternation(left, right):
				return recur(left.value) || recur(right.value)
				
			case let .Concatenation(first, second):
				return recur(first.value) && recur(second.value)
				
			case .Repetition:
				return true
				
			case let .Reduction(c, _):
				return recur(c.value)
				
			default:
				return false
			}
		}
		return nullable(self)
	}
}
