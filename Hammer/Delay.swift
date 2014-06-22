//  Copyright (c) 2014 Rob Rix. All rights reserved.

/// Takes an unevaluated closure \c value and returns a lazily-evaluating wrapper for it.
func delay<T>(value: @auto_closure () -> T) -> Delay<T> {
	return Delay(thunk: value)
}

/// A lazily-provided value, convertible to its underlying type.
@final class Delay<T : Equatable> {
	var _thunk: (() -> T)?
	var _value: Box<T?>
	
	init(thunk: () -> T) {
		_thunk = thunk
		_value = box(nil)
	}
	
	@conversion func __conversion() -> T {
		if let thunk = _thunk {
			_value = box(thunk())
			_thunk = nil
		}
		return _value!
	}
}

func == <T : Equatable> (left: Delay<T>, right: Delay<T>) -> Bool {
	return ((left as T) == (right as T))
}

extension Delay : Equatable {}
