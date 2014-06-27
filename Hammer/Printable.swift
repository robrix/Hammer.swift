//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Combinator conforms to Printable.
extension Combinator : Printable {
	var description: String {
		return describe(self)
	}
}


/// Pretty-prints the language represented by a combinator.
func describe<Alphabet : Alphabet>(combinator: Combinator<Alphabet>) -> String {
	let describe: Combinator<Alphabet> -> String = fixpoint("S") { recur, combinator in
		switch combinator.language {
		case .Empty:
			return "∅"
			
		case let .Null(parses):
			let joined = join(" ", map(parses) { return $0.description })
			return "ε↓{\(joined)}"
			
			
		case let .Literal(c):
			return "'\(c)'"
			
			
		case let .Alternation(left, right):
			return "(\(recur(left)) ∪ \(recur(right)))"
			
			
		case let .Concatenation(first, second) where first == second:
			return "\(recur(first))+"
			
		case let .Concatenation(first, second):
			return "(\(recur(first)) ✕ \(recur(second)))"

			
		case let .Repetition(language):
			return "\(recur(language))*"
			
			
		case let .Reduction(language, _):
			return "\(recur(language)) → 𝑓"
		}
	}
	return describe(combinator)
}
