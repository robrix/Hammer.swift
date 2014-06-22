//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Constructs the alternation of \c left and \c right.
@infix func | <T where T : Equatable, T : Printable> (left: @auto_closure () -> Language<T>, right: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Alternation(delay(left), delay(right))
}


/// The concatenation operator.
operator infix ++ {}

/// Constructs the concatenation of \c first and \c second.
@infix func ++ <T> (first: @auto_closure () -> Language<T>, second: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Concatenation(delay(first), delay(second))
}


/// Constructs the intersection of \c left and \c right.
//@infix func & <T> (left: @auto_closure () -> Language<T>, right: @auto_closure () -> Language<T>) -> Language<T> {
//	return Language.Intersection(delay(left), delay(right))
//}


/// The Kleene star, or zero-or-more repetition operator.
operator postfix * {}

/// Constructs the zero-or-more repetition of \c language.
///
/// \code
///     language*
@postfix func * <T> (language: @auto_closure () -> Language<T>) -> Language<T> {
	return Language.Repeat(delay(language))
}


/// The one-or-more repetition operator.
operator postfix + {}

/// Constructs the one-or-more repetition of \c language.
///
/// This is syntactic sugar, producing the concatenation of \c language with its zero-or-more repetition, which is equivalent to `+` in e.g. regular expressions.
///
/// \code
///     language+
@postfix func + <T> (language: @auto_closure () -> Language<T>) -> Language<T> {
	return language ++ language*
}


/// The reduction operator.
operator infix --> {}

/// Constructs the reduction of \c language by a function \c f.
/// 
/// \code
///     language --> { $0 }
@infix func --> <T> (language: @auto_closure () -> Language<T>, f: (T) -> Any) -> Language<T> {
	return Language.Reduce(delay(language), f)
}
