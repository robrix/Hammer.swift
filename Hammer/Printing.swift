//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Language : Printable {
	/// Pretty-prints the language to a string.
	var description: String {
		switch self {
		case .Empty: return "∅"
		case let .Null(parses): return "ε↓{\(parses)}"
			
		case let .Literal(c): return "'\(c)'"
			
		case let .Alternation(left, right): return "\(left) ∪ \(right)"
			//		case let .Concatenation(language, .Repeat(language)): "\(language)+"
		case let .Concatenation(first, second): return "\(first) ✕ \(second)"
		case let .Intersection(left, right): return "\(left) ∩ \(right)"
			
		case let .Repeat(language): return "\(language)*"
			
		case let .Reduce(language, _): return "\(language) → 𝑓"
		}
	}
}
