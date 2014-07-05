//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// A binary tree with .Nil as the terminating case.
enum BinaryTree<T : Hashable> {
	case Nil
	case Leaf(Box<T>)
	case Branch(Box<BinaryTree<T>>, Box<BinaryTree<T>>)
}


/// BinaryTree conforms to Equatable.
func == <T> (a: BinaryTree<T>, b: BinaryTree<T>) -> Bool {
	switch (a, b) {
	case (.Nil, .Nil):
		return true
	case let (.Leaf(x), .Leaf(y)) where x == y:
		return true
	case let (.Branch(x1, y1), .Branch(x2, y2)) where x1.value == x2.value && y1.value == y2.value:
		return true
	default:
		return false
	}
}


/// BinaryTree conforms to Hashable.
extension BinaryTree : Hashable {
	var hashValue: Int {
		switch self {
		case .Nil:
			return 0
			
		case let .Leaf(x):
			return x.value.hashValue
			
		case let .Branch(x, y):
			return x.value.hashValue ^ y.value.hashValue
		}
	}
}
