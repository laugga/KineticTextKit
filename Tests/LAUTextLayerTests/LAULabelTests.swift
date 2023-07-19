import XCTest
@testable import LAUTextLayer

@available(iOS 14.0, *)
final class LAULabelTests: XCTestCase {

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LAULabel(text: "Hello, World!", font: .systemFont(ofSize: 15), textColor: .black).text, "Hello, World!")
    }
}
