//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

/// Constructs the alternation of \c left and \c right.
func | <Alphabet : Alphabet> (left: @autoclosure () -> Combinator<Alphabet>, right: @autoclosure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return Combinator(.Alternation(Delay(left), Delay(right)))
}


/// The concatenation operator.
infix operator ++ { associativity right precedence 145 }

/// Constructs the concatenation of \c first and \c second.
func ++ <Alphabet : Alphabet> (first: @autoclosure () -> Combinator<Alphabet>, second: @autoclosure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return Combinator(Language.Concatenation(Delay(first), Delay(second)))
}


/// The Kleene star, or zero-or-more repetition operator.
postfix operator * {}

/// Constructs the zero-or-more repetition of \c language.
///
/// \code
///     language*
postfix func * <Alphabet : Alphabet> (language: @autoclosure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return Combinator(Language.Repetition(Delay(language)))
}


/// The one-or-more repetition operator.
postfix operator + {}

/// Constructs the one-or-more repetition of \c language.
///
/// This is syntactic sugar, producing the concatenation of \c language with its zero-or-more repetition, which is equivalent to `+` in e.g. regular expressions.
///
/// \code
///     language+
postfix func + <Alphabet : Alphabet> (language: @autoclosure () -> Combinator<Alphabet>) -> Combinator<Alphabet> {
	return language ++ language*
}


/// The reduction operator.
infix operator --> {}

/// Constructs the reduction of \c language by a function \c f.
/// 
/// \code
///     language --> { $0 }
func --> <Alphabet : Alphabet> (language: @autoclosure () -> Combinator<Alphabet>, f: Alphabet -> Any) -> Combinator<Alphabet> {
	return Combinator(Language.Reduction(Delay(language), f))
}


extension Combinator {
	/// Constructs a literal combinator.
	convenience init(literal: Alphabet) {
		self.init(.Literal(box(literal)))
	}
	
	/// Constructs a null parse.
	convenience init(parsed: ParseTree<Alphabet>) {
		self.init(.Null(parsed))
	}
	
	class var empty: Recur {
		return Combinator(.Empty)
	}
}
