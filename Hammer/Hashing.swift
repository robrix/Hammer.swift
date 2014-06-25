//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Hashable conformance.
extension Language : Hashable {
	var hashValue: Int {
		return computeHash(self)
	}
	
	var computeHash: Language<Alphabet> -> Int = fixpoint(0) { (recur: Language<Alphabet> -> Int, language: Language<Alphabet>) -> Int in
		switch language {
		case .Empty:
			return 0
		
		case let .Null(parses):
			return parses.reduce(parses.count) { hash, each in hash ^ each.hashValue }
			
			
		case let .Literal(c):
			return Hammer.hashValue(c)
			
			
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
}
