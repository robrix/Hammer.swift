//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which can be destructured into a pattern which can be matched with a switch/case, e.g. an enum or a tuple.
protocol Destructurable {
	typealias Pattern
	func destructure() -> Pattern
}


func destructure2<Alphabet : Alphabet>(language: Language<Alphabet, Combinator<Alphabet>>) -> Language<Alphabet, Language<Alphabet, Combinator<Alphabet>>> {
	switch language {
	case .Empty:
		return .Empty
		
	case let .Null(x):
		return .Null(x)
		
	case let .Literal(x):
		return .Literal(x)
		
//	case let .Alternation(x, y):
//		// fixme: this should unpack to the alternation of the evaluation of x and y
//		// fixme: need to delay these or put the delay in Recur
//		return .Alternation(x.forced.language, y.forced.language)
//		
	default:
		return .Empty
	}
}
