//  Copyright (c) 2014 Rob Rix. All rights reserved.

// Adapted from WWDC2014 session 404 Advanced Swift.
func fixpoint<Parameter : Hashable, Result> (initial: Result, body: (Parameter -> Result, Parameter) -> Result) -> (Parameter) -> Result {
	var memo = Dictionary<Parameter, Result>()
	var recursive: ((Parameter) -> Result)!
	recursive = { parameter in
		if let q = memo[parameter] { return q }
		memo[parameter] = initial
		let result = body(recursive, parameter)
		memo[parameter] = result
		return result
	}
	return recursive
}
