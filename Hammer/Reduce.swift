//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Traverse a recursive language.
extension Language : Testable {
	func reduce<Into>(initial: Into, combine: (Into, Language<Alphabet>) -> Into) -> Into {
		var memo = Dictionary<Language<Alphabet>, Into>()
		return _reduce(memo, self, initial, combine)
	}
	
	static func performTests() {
		func count(language: Language<String>) -> Int {
			return language.reduce(0) { into, each in into + 1 }
		}
		
		let empty: Language<String> = Language<String>.Empty
		assert(count(empty) == 1)
		
		let repetition = empty*
		assert(count(repetition) == 2)
		
		let concatenation = empty+
		assert(count(concatenation) == 4)
		
		var cyclic: Language<String> = empty
		cyclic = empty ++ cyclic ++ empty | empty
		assert(count(cyclic) == 7)
	}
}

func _reduce<Into, Alphabet>(var memo: Dictionary<Language<Alphabet>, Into>, language: Language<Alphabet>, initial: Into, combine: (Into, Language<Alphabet>) -> Into) -> Into {
	if let cached = memo[language] { return cached }
	
	memo[language] = initial
	var into = combine(initial, language)
	memo[language] = into
	
	switch language {
		case .Empty:
			fallthrough
		case .Null:
			fallthrough
		case .Literal:
			break
		
		case let .Alternation(left, right):
			into = _reduce(memo, left, into, combine)
			into = _reduce(memo, right, into, combine)
		
		case let .Concatenation(first, second):
			into = _reduce(memo, first, into, combine)
			into = _reduce(memo, second, into, combine)
		
		
		case let .Repetition(language):
			into = _reduce(memo, language, into, combine)
		
		case let .Reduction(language, _):
			into = _reduce(memo, language, into, combine)
	}
	
	return into
}
