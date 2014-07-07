//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

extension Combinator {
	/// Parse a sequence element by element and return the corresponding parse trees (if any).
	func parse<S : Sequence where S.GeneratorType.Element == Alphabet>(sequence: S) -> ParseTree<Alphabet> {
		return reduce(sequence, self) { parser, term in
			parser.derive(term).compact()
		}.parseForest
	}
}

struct ParsingTests : Testable {
	static func _performTests() {
		let xs = Combinator(literal: "x")*
		assert(xs.parse([]).count == 0)
//		assert(xs.parse([""]).count == 0)
//		let parsedX = xs.parse(["x"])
//		println(parsedX)
//		assert(parsedX.count == 1)
	}
}
