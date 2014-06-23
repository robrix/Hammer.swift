//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Hashable conformance.
extension Language : Hashable {
	var hashValue: Int {
		switch self {
		case .Empty:
			return 0
			
		case let .Null(parses):
			return parses.reduce(parses.count) { hash, each in hash ^ each.hashValue }
			
			
		case let .Literal(c):
			return Hammer.hashValue(c)
			
			
		case let .Alternation(left, right):
			return "Alternation".hashValue ^ Hammer.hashValue(left) ^ Hammer.hashValue(right)
			
		case let .Concatenation(first, second):
			return "Concatenation".hashValue ^ Hammer.hashValue(first) ^ Hammer.hashValue(second)
		
			
		case let .Repetition(language):
			return "Repetition".hashValue ^ Hammer.hashValue(language)
			
			
		case let .Reduction(language, _):
			return "Reduction".hashValue ^ Hammer.hashValue(language)
		}
	}
}


//let hashValue = fixpoint(0) { hashValue, language in
//	switch language {
//	case .Empty:
//		return 0
//	case let .Null(parses):
//		return parses.reduce(parses.count) { hash, each in hash ^ each.hashValue }
//	
//	default:
//		return 0
//	}
//}
