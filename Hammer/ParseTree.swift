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
	
	init<S : Sequence where S.GeneratorType.Element == ParseTree<T>>(trees: S) {
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


/// ParseTree conforms to Printable.
extension ParseTree : Printable {
	var description: String {
		switch self {
		case .Nil:
			return "()"
		
		case let .Leaf(x):
			return toString(x.value)
			
		case let .Branch(x, y):
			return "(\(x.value.description) . \(y.value.description))"
			
		case let .Choice(x):
			return x.description
		}
	}
}


func +<T> (a: ParseTree<T>, b: ParseTree<T>) -> ParseTree<T> {
	switch (a, b) {
	case let (x, .Nil):
		return x
	case let (.Nil, y):
		return y
	
	case let (.Choice(x), .Choice(y)):
		return ParseTree(trees: x + y)
		
	case let (.Choice(x), y):
		let trees: Set<ParseTree<T>> = x + [y]
		return ParseTree(trees: trees)
		
	case let (x, .Choice(y)):
		let trees: Set<ParseTree<T>> = y + [x]
		return ParseTree(trees: trees)
		
	case let (x, y):
		return ParseTree(trees: [x] + [y])
		
	default:
		return .Nil
	}
}


func toMap<T, U> (f: T -> () -> U) -> T -> U {
	return { x in f(x)() }
}

func toMap<T, U> (f: @auto_closure () -> U) -> T -> U {
	return { x in f() }
}


extension ParseTree {
	var count: Int { return _count() }
	func _count() -> Int {
		switch self {
			case .Nil:
				return 0
			
			case .Leaf:
				return 1
			
			case let .Branch(x, y):
				return x.value.count + y.value.count
			
			case let .Choice(choices):
				return reduce(map(choices, toMap(ParseTree._count)), 0, +)
		}
	}
}


// fixme: cons
// fixme: cartesian product
