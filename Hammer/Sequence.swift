//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Concatenation of Sequences.
func ++ <A : SequenceType, B : SequenceType, Element where Element == A.Generator.Element, Element == B.Generator.Element>(var a: A, var b: B) -> SequenceOf<Element> {
	return SequenceOf {
		a.generate() ++ b.generate()
	}
}
