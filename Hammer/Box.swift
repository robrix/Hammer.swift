//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Boxes \c value up for use in recursive structs/enums or parameterized classes.
///
/// This is a currently-required implementation detail to handle the compiler’s lack of codegen for recursive enum/struct definitions, and classes with non-fixed layout.
func box<T>(value: T) -> Box<T> {
	return Box(value)
}

/// A box for a value which would otherwise because you can’t have recursive enum/struct definitions. OnHeap could be used if we could produce an ObjectIdentifier or otherwise make it Identifiable.
class Box<T> {
	let value: T
	
	init(_ value: T) {
		self.value = value
	}
	
	func __conversion() -> T {
		return value
	}
}


extension Box : Identifiable {
	var identity: ObjectIdentifier { return reflect(self).objectIdentifier! }
}


func == <Boxed : Equatable>(a: Box<Boxed>, b: Box<Boxed>) -> Bool {
	return a.value == b.value
}


func hash<Boxed : Hashable>(box: Box<Boxed>) -> Int {
	return box.value.hashValue
}


func toString<T>(box: Box<T>) -> String {
	return toString(box.value)
}
