//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

extension Combinator {
	/// Parse a sequence element by element and return the corresponding parse trees (if any).
	func parse<S : Sequence where S.GeneratorType.Element == Alphabet>(sequence: S) -> Set<Alphabet> {
		return reduce(sequence, self) { parser, term in
			derive(parser, term).compact()
		}.parseForest
	}
}

struct ParsingTests : Testable {
	static func _performTests() {
		let xs = Combinator(literal: "x")*
		let nullParses = xs.parse([""])
		assert(nullParses.count == 0)
	}
}
