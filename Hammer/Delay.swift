//  Copyright (c) 2014 Rob Rix. All rights reserved.

func delay<T>(thunk: @auto_closure () -> T) -> Delay<T> {
	return Delay(thunk: thunk)
}

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
