import XCTest
@testable import KineticTextKit

final class KineticTextLayerTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let layer = KineticTextLayer()
        layer.text = "Hello, World!"
        XCTAssertEqual(layer.text, "Hello, World!")
    }
}
