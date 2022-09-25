import XCTest
@testable import CocoaKit

final class ColorTests: XCTestCase {

    func testColor() throws {
        let color = NSColor(hex: 0xCC00FF)
        XCTAssertEqual(color.hex()!, 0xCC00FF)
        XCTAssertEqual(color.hexString(uppercase: true)!, "CC00FF")
        let transparent = NSColor.transparent
        XCTAssertEqual(transparent.hex(alpha: true)!, 0x00000000)
        XCTAssertEqual(transparent.hexString(withAlpha: true, hashtag: true), "#00000000")
    }

}
