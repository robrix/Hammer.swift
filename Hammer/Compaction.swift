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
