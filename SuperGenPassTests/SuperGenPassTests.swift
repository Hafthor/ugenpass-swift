import XCTest
@testable import ugenpass

class SuperGenPassTests: XCTestCase {
    func testExample() throws {
        let actual = SuperGenPass.generate(password: "password", domain: "example.com", length: 10)
        XCTAssertEqual(actual, "aHD8trcRPP")
    }
    
    func testEmpty() throws {
        let actual = SuperGenPass.generate(password: "", domain: "", length: 10)
        XCTAssertEqual(actual, "jRm4RCGdpQ")
    }
    
    func testExtraRounds() throws {
        let actual10 = SuperGenPass.generate(password: "", domain: "example.com", length: 10)
        XCTAssertEqual(actual10, "qZxGBMX886")
        let actual20 = SuperGenPass.generate(password: "", domain: "example.com", length: 20)
        XCTAssertEqual(actual20, "mcMqCsxCVOyfn817awB6")
    }
}
