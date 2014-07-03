//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which has a hashable identifier. This can easily be conformed to by any class instance by returning `reflect(self).objectIdentifier!`.
protocol Identifiable {
	typealias Identifier : Hashable
	var identity: Identifier { get }
}


/// Combinator conforms to Identifiable.
extension Combinator : Identifiable {
	var identity: ObjectIdentifier { return reflect(self).objectIdentifier! }
}


/// Character conforms to Identifiable.
extension Character : Identifiable {
	var identity: String { return String(self) }
}
