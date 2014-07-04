//  Copyright (c) 2014 Rob Rix. All rights reserved.

import List
import Set

/// Returns a combinator equivalent to \c combinator but more compact.
///
/// If the language cannot be compacted, it is returned unchanged.
func compact<Alphabet : Alphabet>(combinator: Combinator<Alphabet>) -> Combinator<Alphabet> {
	let compact: Combinator<Alphabet> -> Combinator<Alphabet> = fixpoint(combinator) { recur, combinator in
		switch combinator.language {
		
		/// Alternations with Empty are equivalent to the other alternative.
		case let .Alternation(x, y) where recur(x).language == .Empty:
			return recur(y)
		case let .Alternation(x, y) where recur(y).language == .Empty:
			return recur(x)
		
		/// Concatenations with Empty are equivalent to Empty.
		case let .Concatenation(x, y) where recur(x).language == .Empty || recur(y).language == .Empty:
			return Combinator(.Empty)
		
		/// Repetitions of empty cannot parse.
		case let .Repetition(x) where recur(x).language == .Empty:
			// fixme: how does this even work? List() is not in Alphabet.
			return Combinator(.Null(Set(List())))
			
		/// Reductions of reductions compose.
		case let .Reduction(x, f):
//			switch recur(x).language {
//			case let .Reduction(y, g):
//				let composition: Alphabet -> Any = compose(g, f)
//				return Combinator(.Reduction(y, composition))
//			default:
//				break
//			}
			fallthrough
		
		default:
			return combinator
		}
	}
	return compact(combinator)
}



extension Combinator {
	func compact() -> Combinator<Alphabet> {
		switch self.destructure() {
		/// Alternations with Empty are equivalent to the other alternative.
		case let .Alternation(x, .Empty):
			return Combinator(x)
		case let .Alternation(.Empty, y):
			return Combinator(y)
			
		/// Concatenations with Empty are equivalent to Empty.
		case .Concatenation(.Empty, _), .Concatenation(_, .Empty):
			return Combinator(.Empty)
			
		/// Repetitions of empty are equivalent to parsing the empty string.
		case .Repetition(.Empty):
			return Combinator(.Null(Set(List())))
			
		/// Reductions of reductions compose.
//		case let .Reduction(.Reduction(x, f), g):
//			let composed = compose(g, f)
//			return Combinator(.Reduction(x, composed))
		default:
			return self
		}
	}
}

struct CompactionTests : Testable {
	static func _performTests() {
		let literal = Combinator(literal: "x")
		assert(literal == literal)
		let empty = Combinator<String>(.Empty)
		
		let literalConcatEmpty = (literal ++ empty).compact()
		assert(literalConcatEmpty == empty)
		let emptyConcatLiteral = (empty ++ literal).compact()
		assert(emptyConcatLiteral == empty)
		
		let literalAltEmpty = (literal | empty).compact()
		assert(literalAltEmpty == literal)
		let emptyAltLiteral = (empty | literal).compact()
		assert(emptyAltLiteral == literal)
	}
}
