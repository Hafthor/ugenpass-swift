import XCTest
@testable import ugenpass

class ugenpassTests: XCTestCase {
    func testExample() throws {
        let actual = UGenPass.generate(pwd: "password", domain: "example.com")
        XCTAssertEqual(actual, "dc2Cs!HL6WZ!mY3Pm(YI8If")
    }
    
    func testEmpty() throws {
        let actual = UGenPass.generate(pwd: "", domain: "")
        XCTAssertEqual(actual, "fJ8IJ.GR3Su!oa9Mf(Ns3aS")
    }
}
