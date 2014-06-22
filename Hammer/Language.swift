//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// The definition of a context-free language whose individual elements are of type `T`.
enum Language<T where T : Printable, T : Equatable> {
	/// The empty language, i.e. the language which accepts nothing.
	case Empty
	
	/// A null language, i.e. a language which accepts the empty string.
	///
	/// Its parameter is a parse forest of recognized input.
	case Null(T[])
	
	/// A literal, i.e. matches the literal of type `T`.
	case Literal(Box<T>)
	
	case Alternation(Delay<Language<T>>, Delay<Language<T>>)
	case Concatenation(Delay<Language<T>>, Delay<Language<T>>)
	case Intersection(Delay<Language<T>>, Delay<Language<T>>)
	
	case Repeat(Delay<Language<T>>)
	
	case Reduce(Delay<Language<T>>, (T) -> Any)
}

extension Language : Printable {
	var description: String {
		switch self {
		case .Empty: return "∅"
		case let .Null(parses): return "ε↓{\(parses)}"
		
		case let .Literal(c): return "'\(c)'"
		
		case let .Alternation(left, right): return "\(left) ∪ \(right)"
		case let .Concatenation(language, .Repeat(language)): "\(language)+"
		case let .Concatenation(first, second): return "\(first) ✕ \(second)"
		case let .Intersection(left, right): return "\(left) ∩ \(right)"
		
		case let .Repeat(language): return "\(language)*"
		
		case let .Reduce(language, _): return "\(language) → 𝑓"
		}
	}
}

extension Language : Equatable {}


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
