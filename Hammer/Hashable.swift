//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Combinator conforms to Hashable.
extension Combinator : Hashable {
	// fixme: define a new fixpoint() variant which assigns a property instead of memoizing in a dictionary
	
	/// Hashes the receiver recursively.
	var hashValue: Int {
		let hash: Combinator<Alphabet> -> Int = fixpoint(0) { recur, combinator in
			switch combinator.language {
			case .Empty:
				return 0
				
			case let .Null(parses):
				return parses.hashValue
				
				
			case let .Literal(c):
				return Hammer.hash(c)
				
				
			case let .Alternation(left, right):
				return "Alternation".hashValue ^ recur(left.value) ^ recur(right.value)
				
			case let .Concatenation(first, second):
				return "Concatenation".hashValue ^ recur(first.value) ^ recur(second.value)
				
				
			case let .Repetition(language):
				return "Repetition".hashValue ^ recur(language.value)
				
				
			case let .Reduction(language, _):
				return "Reduction".hashValue ^ recur(language.value)
			}
		}
		return hash(self)
	}
}
