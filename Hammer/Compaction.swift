//  Copyright (c) 2014 Rob Rix. All rights reserved.

import List
import Set

extension Combinator {
	/// Returns a combinator equivalent to \c combinator but more compact.
	///
	/// If the language cannot be compacted, it is returned unchanged.
	func compact() -> Combinator<Alphabet> {
		let compact: Recur -> Recur = fixpoint(self) { recur, combinator in
			switch combinator.destructure(recur) {
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
//			case let .Reduction(.Reduction(x, f), g):
//				let composed = compose(g, f)
//				return Combinator(.Reduction(x, composed))
			default:
				return combinator
			}
		}
		return compact(self)
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
		
		var cyclic: Combinator<String>!
		cyclic = cyclic ++ empty | literal
		assert(cyclic.compact() == literal)
	}
}
