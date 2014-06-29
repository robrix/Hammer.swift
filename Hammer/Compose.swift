//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Returns the composition of \c g on \c f, i.e. g ∘ f.
func compose<X, Y, Z>(g: Y -> Z, f: X -> Y) -> X -> Z {
	return { x in g(f(x)) }
}
