enum Language<T : Printable> {
	typealias LazyLanguage = () -> Language<T>
	
	case Empty
	case Null(T[])
	
	case Literal(T)
	
	case Alternation(LazyLanguage, LazyLanguage)
	case Concatenation(LazyLanguage, LazyLanguage)
	case Intersection(LazyLanguage, LazyLanguage)
	
	case Repeat(LazyLanguage)
	
	case Reduce(LazyLanguage, (T) -> Any)
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


@infix func | <T> (left: @auto_closure () -> Language<T>, right: @auto_closure () -> Language<T>) -> Language<T> {
	return Language<T>.Alternation(left, right)
}


operator infix ++ {}

@infix func ++ <T> (first: @auto_closure () -> Language<T>, second: @auto_closure () -> Language<T>) -> Language<T> {
	return Language<T>.Concatenation(first, second)
}

@infix func & <T> (left: @auto_closure () -> Language<T>, right: @auto_closure () -> Language<T>) -> Language<T> {
	return Language<T>.Intersection(left, right)
}

operator postfix * {}

@postfix func * <T> (language: @auto_closure () -> Language<T>) -> Language<T> {
	return Language<T>.Repeat(language)
}


operator postfix + {}

@postfix func + <T> (language: @auto_closure () -> Language<T>) -> Language<T> {
	return language ++ language*
}


operator infix --> {}

@infix func --> <T> (language: @auto_closure () -> Language<T>, f: (T) -> Any) -> Language<T> {
	return Language<T>.Reduce(language, f)
}
