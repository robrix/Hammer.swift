//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which can be destructured into a pattern which can be matched with a switch/case, e.g. an enum or a tuple.
protocol Destructurable {
	typealias Pattern
	func destructure() -> Pattern
}


func destructure<Alphabet : Alphabet>(language: Language<Alphabet, Combinator<Alphabet>>) -> Language<Alphabet, Language<Alphabet, Combinator<Alphabet>>> {
	switch language {
	case .Empty:
		return .Empty
		
	case let .Null(x):
		return .Null(x)
		
	case let .Literal(x):
		return .Literal(x)
		
	// fixme: these should unpack to the alternation of the evaluation of x and y, rather than the delay of those, but we cannot currently put the delay in Recur rdar://17520072
	case let .Alternation(x, y):
		return .Alternation(delay(x.forced.language), delay(y.forced.language))
		
	case let .Concatenation(x, y):
		return .Concatenation(delay(x.forced.language), delay(y.forced.language))
		
	case let .Repetition(x):
		return .Repetition(delay(x.forced.language))
		
	case let .Reduction(x, f):
		return .Reduction(delay(x.forced.language), f)
	}
}
