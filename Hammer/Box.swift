//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Boxes \c value up for use in recursive structs/enums or parameterized classes.
///
/// This is a currently-required implementation detail to handle the compiler’s lack of codegen for recursive enum/struct definitions, and classes with non-fixed layout.
func box<T>(value: T) -> Box<T> {
	return Box(value: value)
}

/// A box for a value which would otherwise cause compiler issues: recursive enum/struct definitions, and classes with non-fixed layout.
@final class Box<T> {
	let _value: T[]
	
	var value: T { return _value[0] }
	
	init(value: T) {
		_value = [ value ]
	}
	
	@conversion func __conversion() -> T {
		return value
	}
}


func == <Boxed : Equatable>(a: Box<Boxed>, b: Box<Boxed>) -> Bool {
	return a.value == b.value
}


func hashValue<Boxed : Hashable>(box: Box<Boxed>) -> Int {
	return box.value.hashValue
}
