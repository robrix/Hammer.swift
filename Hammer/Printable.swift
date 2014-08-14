//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Combinator conforms to Printable.
extension Combinator : Printable {
	/// Pretty-prints the language represented by a combinator.
	var description: String {
		let describe: Combinator<Alphabet> -> String = fixpoint("S") { recur, combinator in
			switch combinator.language {
			case .Empty:
				return "∅"
				
			case let .Null(parses):
				return "ε↓{\(parses.description)}"
				
				
			case let .Literal(c):
				return "'\(toString(c))'"
				
				
			case let .Alternation(left, right):
				return "(\(recur(left.value)) ∪ \(recur(right.value)))"
				
				
			case let .Concatenation(first, second) where first == second:
				return "\(recur(first.value))+"
				
			case let .Concatenation(first, second):
				return "(\(recur(first.value)) ✕ \(recur(second.value)))"
				
				
			case let .Repetition(language):
				return "\(recur(language.value))*"
				
				
			case let .Reduction(language, _):
				return "\(recur(language.value)) → 𝑓"
			}
		}
		return describe(self)
	}
}
