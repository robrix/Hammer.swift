//  Copyright (c) 2014 Rob Rix. All rights reserved.

func == <T> (left: Language<T>, right: Language<T>) -> Bool {
	switch (left, right) {
	case (.Empty, .Empty): return true
	case let (.Null(x), .Null(y)): return x == y
		
	case let (.Literal(x), .Literal(y)): return x == y
		
	default: return false
	}
}
