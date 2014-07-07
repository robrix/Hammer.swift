//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Takes an unevaluated closure \c value and returns a lazily-evaluating wrapper for it.
func delay<T>(value: @auto_closure () -> T) -> Delay<T> {
	return Delay(value)
}

/// A lazily-provided value, convertible to its underlying type.
@final class Delay<T> {
	var _thunk: (() -> T)?
	var _value: Box<T?>
	
	var forced: T { return __conversion() }
	@lazy var value: T = { self._thunk!() }()
	
	init(_ thunk: () -> T) {
		_thunk = thunk
		_value = box(nil)
	}
	
	@conversion func __conversion() -> T {
		return value
	}
}


func == <T : Equatable> (left: Delay<T>, right: Delay<T>) -> Bool {
	return ((left as T) == (right as T))
}

func == <T : Equatable> (left: Delay<T>, right: T) -> Bool {
	return (left as T) == right
}


func hash<Delayed : Hashable>(delay: Delay<Delayed>) -> Int {
	return (delay as Delayed).hashValue
}
