//  Copyright (c) 2014 Rob Rix. All rights reserved.

func derive<Alphabet : Alphabet>(combinator: Combinator<Alphabet>, character: Alphabet) -> Combinator<Alphabet> {
	let derive: (Combinator<Alphabet>, Alphabet) -> Combinator<Alphabet> = fixpoint(combinator, { HashablePair($0.identity, $1) }) { recur, parameters in
		switch combinator.language {
		case let .Literal(c) where c == character:
			return Combinator(Language.Null([c]))
		case let .Literal(c):
			return Combinator(Language.Empty)
			
		case let .Alternation(x, y):
			return Combinator(Language.Alternation(delay(recur(x, character)), delay(recur(y, character))))
			
		case let .Concatenation(x, y) where nullable(x):
			return recur(x, character) ++ y | recur(y, character)
		case let .Concatenation(x, y):
			return recur(x, character) ++ y
			
		case let .Repetition(x):
			return recur(x, character) ++ combinator
			
		case let .Reduction(x, f):
			return recur(x, character) --> f
			
		default:
			return combinator
		}
	}
	return derive(combinator, character)
}
