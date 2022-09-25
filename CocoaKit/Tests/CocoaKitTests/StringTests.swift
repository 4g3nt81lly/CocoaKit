import XCTest
@testable import CocoaKit

final class StringTests: XCTestCase {

    func testString() throws {
        var greeting = "hello, world!"
        XCTAssertEqual(greeting[-3 ..< 4], nil)
        greeting[..<5] = "hi"
        XCTAssertEqual(greeting, "hi, world!")
    }

}
