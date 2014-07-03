import XCTest
import Hammer

class Tests: XCTestCase {
	func testCombinatorFixpoints() {
		Combinator<String>._performTests()
	}
	
	func testParsing() {
		ParsingTests._performTests()
	}
}
