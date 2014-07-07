//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Concatenation of Generators.
func ++ <A : Generator, B : Generator, Element where Element == A.Element, Element == B.Element>(var a: A, var b: B) -> GeneratorOf<Element> {
	return GeneratorOf {
		switch a.next() {
		case .None:
			return b.next()
		case let .Some(x):
			return x
		}
	}
}
