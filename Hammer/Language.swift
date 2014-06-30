//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

/// The definition of a context-free language whose individual elements are of type `Alphabet`.
///
/// `Recur` is the type through which recursion is handled, allowing languages to have state associated with them, but without requiring them to include it in each of their definitions. For context-free languages, `Recur` can be expected to have a `language` property with the appropriate types for `Recur` and `Alphabet`.
enum Language<Alphabet : Alphabet, Recur> {
	/// The empty language, i.e. the language which accepts nothing.
	case Empty
	
	/// A null language, i.e. a language which accepts the empty string.
	///
	/// Its parameter is a parse forest of recognized input.
	case Null(Set<Alphabet>)
	
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
	case Reduction(Delay<Recur>, Alphabet -> Any)
	
	// Any desired state has to be mediated by the Recur type because enumerations cannot hold noncomputed properties. rdar://17500738
}


/// Equality on Languages. This is nonrecursive equality of the enum tag itself, not its state.
func == <Alphabet : Alphabet, Recur> (a: Language<Alphabet, Recur>, b: Language<Alphabet, Recur>) -> Bool {
	switch (a, b) {
	case (.Empty, .Empty):
		return true
	case (.Null, .Null):
		return true
	case (.Literal, .Literal):
		return true
	case (.Alternation, .Alternation):
		return true
	case (.Concatenation, .Concatenation):
		return true
	case (.Repetition, .Repetition):
		return true
	case (.Reduction, .Reduction):
		return true
		
	default:
		return false
	}
}
