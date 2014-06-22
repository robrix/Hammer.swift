//  Copyright (c) 2014 Rob Rix. All rights reserved.

// Taken from WWDC2014 session 404 Advanced Swift.
func memoize<Key : Hashable, Value> (body: ((Key) -> Value, Key) -> Value) -> (Key) -> Value {
	var memo = Dictionary<Key, Value>()
	var result: ((Key) -> Value)!
	result = { x in
		if let q = memo[x] { return q }
		let r = body(result, x)
		memo[x] = r
		return r
	}
	return result
}
