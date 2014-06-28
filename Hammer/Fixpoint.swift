//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which has a hashable identifier. This can easily be conformed to by any class instance by returning `reflect(self).objectIdentifier!`.
protocol Identifiable {
	typealias Identifier : Hashable
	var identity: Identifier { get }
}

func fixpoint<Parameter : Identifiable, Result> (initial: Result, body: (Parameter -> Result, Parameter) -> Result) -> Parameter -> Result {
	return fixpoint(initial, { $0.identity }, body)
}

func fixpoint<Parameter : Hashable, Result> (initial: Result, body: ((Parameter, Parameter) -> Result, (Parameter, Parameter)) -> Result) -> (Parameter, Parameter) -> Result {
	return fixpoint(initial, { HashablePair($0.0, $0.1) }, body)
}

/// Construct a memoizing recursive function.
///
/// The returned function is suitable for use in traversing cyclic graphs recursively; parameters are looked up in the cache, and if this lookup fails, then the \c initial value is memoized, the body function is called, and its result memoized.
///
/// Recursion should occur via the \c recur parameter to the body function.
///
/// Initially adapted from the \c memoize function in WWDC2014 session 404 Advanced Swift.
func fixpoint<Parameter, Result, Decorator : Hashable>(initial: Result, wrap: Parameter -> Decorator, body: (Parameter -> Result, Parameter) -> Result) -> Parameter -> Result {
	var memo = Dictionary<Decorator, Result>()
	var recursive: (Parameter -> Result)! = nil
	recursive = { parameter in
		let key = wrap(parameter)
		if let found = memo[key] { return found }
		memo[key] = initial
		let result = body(recursive, parameter)
		memo[key] = result
		return result
	}
	return recursive
}


/// A pair which distributes hashing and equality over its members. This is an implementation detail.
struct HashablePair<T : Hashable, U : Hashable> {
	let left: T
	let right: U
	
	init(_ a: T, _ b: U) {
		left = a
		right = b
	}
}


/// Return an ObjectIdentifier for \c a if possible. Will be \c None for non-class instances, and \c Some for class instances.
func identify<T>(a: T) -> ObjectIdentifier? {
	return reflect(a).objectIdentifier
}


/// Distribute equality over hashable pairs.
func == <T, U> (a: HashablePair<T, U>, b: HashablePair<T, U>) -> Bool {
	return identify(a.left)! == identify(b.left)! && identify(a.right)! == identify(b.right)!
}

extension HashablePair : Hashable {
	// This is a poor way to distribute hashing over a pair; it’s convenient, but it’s not a good implementation detail to rely upon or emulate.
	var hashValue: Int {
		return identify(left)!.hashValue ^ identify(right)!.hashValue
	}
}
