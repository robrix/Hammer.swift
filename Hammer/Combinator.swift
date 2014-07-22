//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A combinator over languages, which holds the state used in the derivative of parser combinators.
final class Combinator<Alphabet : Alphabet> {
	typealias Recur = Combinator<Alphabet>
	let language: Language<Alphabet, Recur>
	
	init(_ language: Language<Alphabet, Recur>) {
		self.language = language
	}
}
