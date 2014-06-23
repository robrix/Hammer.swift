//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// The definition of a context-free language whose individual elements are of type `Alphabet`.
enum Language<Alphabet where Alphabet : Printable, Alphabet : Hashable> {
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
	case Alternation(Delay<Language<Alphabet>>, Delay<Language<Alphabet>>)
	
	/// The concatenation of two languages.
	case Concatenation(Delay<Language<Alphabet>>, Delay<Language<Alphabet>>)
	
//	/// The intersection of two languages.
//	case Intersection(Delay<Language<Alphabet>>, Delay<Language<Alphabet>>)
	
	
	/// The repetition of a language 0 or more times.
	case Repetition(Delay<Language<Alphabet>>)
	
	
	/// The reduction of a language by a function.
	case Reduction(Delay<Language<Alphabet>>, (Alphabet) -> Any)
}
