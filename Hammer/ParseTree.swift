//  Copyright (c) 2014 Rob Rix. All rights reserved.

import Set

/// A (potentially ambiguous, but otherwise binary) parse tree.
enum ParseTree<T : Hashable> {
	/// Represents the termination of a branch (list).
	case Nil
	
	/// Represents a leaf node.
	case Leaf(Box<T>)
	
	/// Represents a binary branch node.
	///
	/// S-list–style constructions use this, coupled with .Leaf() and .Nil.
	case Branch(Box<ParseTree<T>>, Box<ParseTree<T>>)
	
	/// Represents an ambiguity in the parse tree.
	case Choice(Set<ParseTree<T>>)
	
	init() {
		self = .Nil
	}
	
	init(leaf: T) {
		self = .Leaf(box(leaf))
	}
	
	init(left: ParseTree<T>, right: ParseTree<T>) {
		self = .Branch(box(left), box(right))
	}
	
	init<S : Sequence where S.GeneratorType.Element == ParseTree<T>>(_ trees: S) {
		let set: Set<ParseTree<T>> = Set(trees)
		switch set.count {
		case 0:
			self = .Nil
		case 1:
			self = set[]
		default:
			self = .Choice(set)
		}
	}
}


/// ParseTree conforms to Equatable.
func == <T> (a: ParseTree<T>, b: ParseTree<T>) -> Bool {
	switch (a, b) {
	case (.Nil, .Nil):
		return true
		
	case let (.Leaf(x), .Leaf(y)) where x == y:
		return true
		
	case let (.Branch(x1, y1), .Branch(x2, y2)) where x1.value == x2.value && y1.value == y2.value:
		return true
		
	case let (.Choice(x), .Choice(y)) where x == y:
		return true
		
	default:
		return false
	}
}


/// ParseTree conforms to Hashable.
extension ParseTree : Hashable {
	var hashValue: Int {
		switch self {
		case .Nil:
			return 0
			
		case let .Leaf(x):
			return x.value.hashValue
			
		case let .Branch(x, y):
			return x.value.hashValue ^ y.value.hashValue
			
		case let .Choice(x):
			return x.hashValue
		}
	}
}


// fixme: cons
// fixme: cartesian product
