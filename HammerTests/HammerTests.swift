import XCTest
import Hammer

class Tests: XCTestCase {
	func testDeriving() {
		DerivingTests._performTests()
	}
	
	func testParsing() {
		ParsingTests._performTests()
	}
	
	func testParseForest() {
		ParseForestTests._performTests()
	}
	
	func testCompaction() {
		CompactionTests._performTests()
	}
}
