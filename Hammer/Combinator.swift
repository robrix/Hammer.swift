//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A combinator over languages, which holds the state used in the derivative of parser combinators.
class Combinator<Alphabet : protocol<Printable, Hashable>> {
	typealias Recur = Combinator<Alphabet>
	let language: Language<Alphabet, Recur>
	
	init(language: Language<Alphabet, Recur>) {
		self.language = language
	}
}


/// Combinator conforms to Identifiable.
extension Combinator : Identifiable {
	var identity: ObjectIdentifier { return reflect(self).objectIdentifier! }
}


/// Combinator conforms to Equatable.
extension Combinator : Equatable {}

/// Equality between two combinators.
func == <Alphabet : protocol<Printable, Hashable>> (left: Combinator<Alphabet>, right: Combinator<Alphabet>) -> Bool {
	// fixme: file a radar about the lack of type parameters for anonymous closures, variables, & constants
	let equal: (Combinator<Alphabet>, Combinator<Alphabet>) -> Bool = fixpoint(true) { recur, a, b in
		switch (a.language, b.language) {
		case (.Empty, .Empty):
			return true
			
		case let (.Null(x), .Null(y)) where x == y:
			return true
			
		case let (.Literal(x), .Literal(y)) where x == y:
			return true
			
		case let (.Alternation(l1, r1), .Alternation(l2, r2)):
			return recur(l1, l2) && recur(r1, r2)
			
		case let (.Concatenation(f1, s1), .Concatenation(f2, s2)):
			return recur(f1, f2) && recur(s1, s2)
			
		case let (.Repetition(x), .Repetition(y)):
			return recur(x, y)
			
		case let (.Reduction(x, _), .Reduction(y, _)):
			return recur(x, y)
			
		default:
			return false
		}
	}
	return equal(left, right)
}
