//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

/// An object which can be destructured into a pattern which can be matched with a switch/case, e.g. an enum or a tuple.
protocol Destructurable {
	typealias Pattern
	func destructure() -> Pattern
}

/// Combinator is Destructurable.
extension Combinator {
	/// Destructures the receiver’s language one level of recursion deep.
	///
	/// I.e. this evaluates the children of the receiver (if the receiver is nonterminal), but does not evaluate their children.
	func destructure(recur: Combinator<Alphabet> -> Combinator<Alphabet>) -> DestructuredLanguage<Alphabet, Recur> {
		switch language {
		case .Empty:
			return .Empty
			
		case let .Null(x):
			return .Null(x)
			
		case let .Literal(x):
			return .Literal(x)
		
		case let .Alternation(x, y):
			return .Alternation(recur(x).language, recur(y).language)
			
		case let .Concatenation(x, y):
			return .Concatenation(recur(x).language, recur(y).language)
			
		case let .Repetition(x):
			return .Repetition(recur(x).language)
			
		case let .Reduction(x, f):
			return .Reduction(recur(x).language, f)
		}
	}
}


// We would like to put Delay<…> in Recur instead of in Language, and have destructure() return Language<Language<Alphabet, Recur>>, but the compiler does not currently do codegen for enums like that (rdar://17520072). This is a hack to work around that, while still allowing us to pattern match recursively.
enum DestructuredLanguage<Alphabet : Alphabet, Recur> {
	case Empty
	case Null(Set<Alphabet>)
	case Literal(Box<Alphabet>)
	case Alternation(Language<Alphabet, Recur>, Language<Alphabet, Recur>)
	case Concatenation(Language<Alphabet, Recur>, Language<Alphabet, Recur>)
	case Repetition(Language<Alphabet, Recur>)
	case Reduction(Language<Alphabet, Recur>, Alphabet -> Any)
}
