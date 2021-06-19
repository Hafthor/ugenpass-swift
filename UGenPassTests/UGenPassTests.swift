import XCTest
@testable import ugenpass

class UGenPassTests: XCTestCase {
    func testExample() throws {
        let actual = UGenPass.generate(password: "password", domain: "example.com")
        XCTAssertEqual(actual, "dc2Cs!HL6WZ!mY3Pm(YI8If")
    }
    
    func testEmpty() throws {
        let actual = UGenPass.generate(password: "", domain: "")
        XCTAssertEqual(actual, "fJ8IJ.GR3Su!oa9Mf(Ns3aS")
    }
    
    func testRounds() throws {
        let actual = UGenPass.generate(password: "password", domain: "example.com", rounds: 10000)
        XCTAssertEqual(actual, "hc5uX!Qb6fT-cU2rm!Cw4Xw")
    }
    
    func testTemplate() throws {
        let actual = UGenPass.generate(password: "password", domain: "example.com", template: ["abcde", "ABCDE", "ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz", "23456789"])
        XCTAssertEqual(actual, "dAc2")
    }
}
