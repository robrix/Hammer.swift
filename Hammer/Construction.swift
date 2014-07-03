//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Constructs the alternation of \c left and \c right.
@infix func | <Alphabet : Alphabet> (left: @auto_closure () -> Combinator<Alphabet>, right: @auto_closure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return Combinator(Language.Alternation(Delay(left), Delay(right)))
}


/// The concatenation operator.
operator infix ++ { associativity right precedence 145 }

/// Constructs the concatenation of \c first and \c second.
@infix func ++ <Alphabet : Alphabet> (first: @auto_closure () -> Combinator<Alphabet>, second: @auto_closure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return Combinator(Language.Concatenation(Delay(first), Delay(second)))
}


/// The Kleene star, or zero-or-more repetition operator.
operator postfix * {}

/// Constructs the zero-or-more repetition of \c language.
///
/// \code
///     language*
@postfix func * <Alphabet : Alphabet> (language: @auto_closure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return Combinator(Language.Repetition(Delay(language)))
}


/// The one-or-more repetition operator.
operator postfix + {}

/// Constructs the one-or-more repetition of \c language.
///
/// This is syntactic sugar, producing the concatenation of \c language with its zero-or-more repetition, which is equivalent to `+` in e.g. regular expressions.
///
/// \code
///     language+
@postfix func + <Alphabet : Alphabet> (language: @auto_closure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return language ++ language*
}


/// The reduction operator.
operator infix --> {}

/// Constructs the reduction of \c language by a function \c f.
/// 
/// \code
///     language --> { $0 }
@infix func --> <Alphabet : Alphabet> (language: @auto_closure () -> Combinator<Alphabet>, f: Alphabet -> Any) -> Combinator<Alphabet> {
	return Combinator(Language.Reduction(Delay(language), f))
}


extension Combinator {
	/// Constructs a literal combinator.
	convenience init(literal: Alphabet) {
		self.init(.Literal(box(literal)))
	}
}
