//  Copyright (c) 2014 Rob Rix. All rights reserved.

extension Language : Printable {
	/// Pretty-prints the language.
	var description: String {
		switch self {
		case .Empty:
			return "∅"
		
		case let .Null(parses):
			let joined = join(" ", map(parses) { return $0.description })
			return "ε↓{\(joined)}"
			
			
		case let .Literal(c):
			return "'\(c)'"
			
			
		case let .Alternation(left, right):
			return "\(left) ∪ \(right)"
			
//		case let .Concatenation(first, .Repeat(second)) where first == second:
//			return "\(first)+"
			
		case let .Concatenation(first, second):
			return "\(first) ✕ \(second)"
			
		case let .Intersection(left, right):
			return "\(left) ∩ \(right)"
			
			
		case let .Repeat(language):
			return "\(language)*"
			
			
		case let .Reduce(language, _):
			return "\(language) → 𝑓"
		}
	}
}
