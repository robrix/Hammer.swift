//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Concatenation of Sequences.
func ++ <A : Sequence, B : Sequence, Element where Element == A.GeneratorType.Element, Element == B.GeneratorType.Element>(var a: A, var b: B) -> SequenceOf<Element> {
	return SequenceOf {
		a.generate() ++ b.generate()
	}
}
