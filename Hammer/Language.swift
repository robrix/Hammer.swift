//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// The definition of a context-free language whose individual elements are of type `Alphabet`.
///
/// `Recur` is the type through which recursion is handled, allowing languages to have state associated with them, but without requiring them to include it in each of their definitions. For context-free languages, `Recur` can be expected to have a `language` property with the appropriate types for `Recur` and `Alphabet`.
enum Language<Alphabet : protocol<Printable, Hashable>, Recur> {
	/// The empty language, i.e. the language which accepts nothing.
	case Empty
	
	/// A null language, i.e. a language which accepts the empty string.
	///
	/// Its parameter is a parse forest of recognized input.
	case Null(Alphabet[])
	
	/// A literal, i.e. matches the literal of type `Alphabet`.
	case Literal(Box<Alphabet>)
	
	
	/// The alternation, or union, of two languages.
	///
	/// Note that if these languages can both recognize the same string, then alternation of the two is ambiguous, and can result in exponential space consumption while parsing.
	case Alternation(Delay<Recur>, Delay<Recur>)
	
	/// The concatenation of two languages.
	case Concatenation(Delay<Recur>, Delay<Recur>)
	
	/// The repetition of a language 0 or more times.
	case Repetition(Delay<Recur>)
	
	
	/// The reduction of a language by a function.
	case Reduction(Delay<Recur>, (Alphabet) -> Any)
	
	// fixme: file a radar for implicit properties of enumerations (i.e. an element of each case but not explicitly enumerated there). This would be ideal as we would be able to use a single type to parse instead of the combination of Combinator and Language.
}
}
