//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// An object which can be destructured into a pattern which can be matched with a switch/case, e.g. an enum or a tuple.
protocol Destructurable {
	typealias Pattern
	func destructure() -> Pattern
}
