//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Combinator conforms to Hashable.
extension Combinator : Hashable {
	// fixme: define a new fixpoint() variant which assigns a property instead of memoizing in a dictionary
	var hashValue: Int {
		return hash(self)
	}
}


/// Hash a combinator.
func hash<Alphabet : Alphabet>(combinator: Combinator<Alphabet>) -> Int {
	let hash: Combinator<Alphabet> -> Int = fixpoint(0) { recur, combinator in
		switch combinator.language {
		case .Empty:
			return 0
			
		case let .Null(parses):
			return parses.reduce(parses.count) { hash, each in hash ^ each.hashValue }
			
			
		case let .Literal(c):
			return Hammer.hash(c)
			
			
		case let .Alternation(left, right):
			return "Alternation".hashValue ^ recur(left) ^ recur(right)
			
		case let .Concatenation(first, second):
			return "Concatenation".hashValue ^ recur(first) ^ recur(second)
			
			
		case let .Repetition(language):
			return "Repetition".hashValue ^ recur(language)
			
			
		case let .Reduction(language, _):
			return "Reduction".hashValue ^ recur(language)
		}
	}
	return hash(combinator)
}
