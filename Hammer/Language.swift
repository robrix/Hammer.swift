enum Language<T : Printable> {
	typealias LazyLanguage = () -> Language<T>
	
	case Empty
	case Null(T[])
	
	case Literal(T)
	
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
