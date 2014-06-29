//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns a combinator equivalent to \c combinator but more compact.
///
/// If the language cannot be compacted, it is just returned.
func compact<Alphabet : Alphabet>(combinator: Combinator<Alphabet>) -> Combinator<Alphabet> {
	switch combinator.language {
	default:
		return combinator
	}
}
