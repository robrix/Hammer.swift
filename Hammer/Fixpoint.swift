//  Copyright (c) 2014 Rob Rix. All rights reserved.

// Adapted from WWDC2014 session 404 Advanced Swift.
func fixpoint<Parameter : Hashable, Result> (initial: Result, body: (Parameter -> Result, Parameter) -> Result) -> Parameter -> Result {
	var memo = Dictionary<Parameter, Result>()
	var recursive: (Parameter -> Result)!
	recursive = { parameter in
		if let q = memo[parameter] { return q }
		memo[parameter] = initial
		let result = body(recursive, parameter)
		memo[parameter] = result
		return result
	}
	return recursive
}



/// Distributes hashing and equality over its members.
struct HashablePair<T : Hashable> {
	let left: T
	let right: T
	
	init(_ a: T, _ b: T) {
		left = a
		right = b
	}
}


/// Return an ObjectIdentifier for \c a if possible. Will be \c None for non-class instances, and \c Some for class instances.
func identify<T>(a: T) -> ObjectIdentifier? {
	return reflect(a).objectIdentifier
}


/// Distribute equality over hashable pairs.
func == <T> (a: HashablePair<T>, b: HashablePair<T>) -> Bool {
	return identify(a.left)! == identify(b.left)! && identify(a.right)! == identify(b.right)!
}

extension HashablePair : Hashable {
	// This is a poor way to distribute hashing over a pair; it’s convenient, but it’s not a good implementation detail to rely upon or emulate.
	var hashValue: Int {
		return identify(left)!.hashValue ^ identify(right)!.hashValue
	}
}
