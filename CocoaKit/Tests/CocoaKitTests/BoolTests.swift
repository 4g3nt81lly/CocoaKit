import XCTest
@testable import CocoaKit

final class BoolTests: XCTestCase {
    
    func testBoolBasic() throws {
        XCTAssertEqual(1, true)
        XCTAssertEqual(-1, true)
        XCTAssertEqual(0, false)
        let floatBool: Bool = 3.14
        XCTAssertEqual(floatBool, true)
        let floatFalseBool: Bool = 0.142857
        XCTAssertEqual(floatFalseBool, false)
        let signedFloatBool: Bool = -3.14
        XCTAssertEqual(signedFloatBool, true)
        let signedFloatFalseBool: Bool = -0.25
        XCTAssertEqual(signedFloatFalseBool, false)
    }
    
    func testBoolAddition() throws {
        XCTAssertEqual(false + false, false)
        XCTAssertEqual(false + true, true)
        XCTAssertEqual(true + false, true)
        XCTAssertEqual(true + true, true)
        XCTAssertEqual(false + 1, 1)
        XCTAssertEqual(true + -3, -2)
        XCTAssertEqual(false + 3.14, 3.14)
        XCTAssertEqual(true + -3.14, -2.14)
        XCTAssertEqual(1 + true, 2)
        XCTAssertEqual(-3 + true, -2)
        XCTAssertEqual(3.14 + true, 3.14 + 1)
        XCTAssertEqual(-3.14 + true, -2.14)
    }
    
    func testBoolSubtraction() throws {
        XCTAssertEqual(false - false, false)
        XCTAssertEqual(false - true, true)
        XCTAssertEqual(true - false, true)
        XCTAssertEqual(true - true, false)
        XCTAssertEqual(false - 1, -1)
        XCTAssertEqual(true - -3, 4)
        XCTAssertEqual(false - 3.14, -3.14)
        XCTAssertEqual(true - -3.14, 1 + 3.14)
        XCTAssertEqual(1 - true, 0)
        XCTAssertEqual(-3 - true, -4)
        XCTAssertEqual(3.14 - true, 2.14)
        XCTAssertEqual(-3.14 - true, -3.14 - 1)
    }
    
    func testBoolMultiplication() throws {
        XCTAssertEqual(false * false, 0)
        XCTAssertEqual(true * true, 1)
        XCTAssertEqual(true * 2, 2)
        XCTAssertEqual(true * -2, -2)
        XCTAssertEqual(true * 3.14, 3.14)
        XCTAssertEqual(true * -3.14, -3.14)
        XCTAssertEqual(2 * true, 2)
        XCTAssertEqual(-2 * true, -2)
        XCTAssertEqual(3.14 * true, 3.14)
        XCTAssertEqual(-3.14 * true, -3.14)
    }
    
    func testBoolDivision() throws {
        XCTAssertEqual(false / true, false)
        XCTAssertEqual(true / false, false)
        XCTAssertEqual(true / true, true)
        XCTAssertEqual(true / 2, 0)
        XCTAssertEqual(true / -2, 0)
        XCTAssertEqual(true / 0.25, 4.0)
        XCTAssertEqual(true / -0.25, -4.0)
        XCTAssertEqual(2 / true, 2)
        XCTAssertEqual(-2 / true, -2)
        XCTAssertEqual(3.14 / true, 3.14)
        XCTAssertEqual(-3.14 / true, -3.14)
    }
    
}
