//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which has a hashable identifier. This can easily be conformed to by any class instance by returning `reflect(self).objectIdentifier!`.
protocol Identifiable {
	typealias Identifier : Hashable
	var identity: Identifier { get }
}
