//  Copyright (c) 2014 Rob Rix. All rights reserved.

func box<T>(value: T) -> Box<T> {
	return Box(value: value)
}

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
