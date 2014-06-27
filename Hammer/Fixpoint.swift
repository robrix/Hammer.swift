//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which has a hashable identifier. This can easily be conformed to by any class instance by returning `reflect(self).objectIdentifier!`.
protocol Identifiable {
	typealias Identifier : Hashable
	var identity: Identifier { get }
}

// Adapted from WWDC2014 session 404 Advanced Swift.
func fixpoint<Parameter : Identifiable, Result> (initial: Result, body: (Parameter -> Result, Parameter) -> Result) -> Parameter -> Result {
	var memo = Dictionary<Parameter.Identifier, Result>()
	var recursive: (Parameter -> Result)!
	recursive = { parameter in
		if let q = memo[parameter.identity] { return q }
		memo[parameter.identity] = initial
		let result = body(recursive, parameter)
		memo[parameter.identity] = result
		return result
	}
	return recursive
}



/// A pair which distributes hashing and equality over its members. This is an implementation detail.
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
