//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// The definition of a context-free language whose individual elements are of type `Alphabet`.
enum Language<Alphabet where Alphabet : Printable, Alphabet : Equatable> {
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
	
	/// The intersection of two languages.
	case Intersection(Delay<Language<Alphabet>>, Delay<Language<Alphabet>>)
	
	
	/// The repetition of a language 0 or more times.
	case Repeat(Delay<Language<Alphabet>>)
	
	
	/// The reduction of a language by a function.
	case Reduce(Delay<Language<Alphabet>>, (Alphabet) -> Any)
}


@infix func | <T where T : Equatable, T : Printable> (left: @auto_closure () -> Language<T>, right: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Alternation(delay(left), delay(right))
}


operator infix ++ {}

@infix func ++ <T> (first: @auto_closure () -> Language<T>, second: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Concatenation(delay(first), delay(second))
}

@infix func & <T> (left: @auto_closure () -> Language<T>, right: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Intersection(delay(left), delay(right))
}

operator postfix * {}

@postfix func * <T> (language: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Repeat(delay(language))
}


operator postfix + {}

@postfix func + <T> (language: @auto_closure () -> Language<T>) -> Language<T> {
	return language ++ language*
}


operator infix --> {}

@infix func --> <T> (language: @auto_closure () -> Language<T>, f: (T) -> Any) -> Language<T> {
	return Language.Reduce(delay(language), f)
}
