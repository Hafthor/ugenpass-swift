import Foundation
import CryptoKit
import CommonCrypto

class UGenPass {
    private static let ROUNDS = 65536
    private static let CAP = Array("ABCDEFGHIJKLMNPQRSTUVWXYZ")
    private static let LWR = Array("abcdefghijkmnopqrstuvwxyz")
    private static let NUM = Array("23456789")
    private static let SYM = Array("!-()$@.")
    private static let ALL = Array(CAP + LWR)
    private static let TEMPLATE = [LWR, ALL, NUM, ALL, ALL, SYM, CAP, ALL, NUM, ALL, ALL, SYM, LWR, ALL, NUM, ALL, ALL, SYM, CAP, ALL, NUM, ALL, ALL]
    
    static func hash(data: Data, rounds: Int) throws -> Data {
        var resultBytes = [UInt8](repeating: 0, count: kCCKeySizeAES256)
        data.withUnsafeBytes { (unsafeData: UnsafePointer<CChar>!) in
            _ = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), unsafeData, data.count, nil, 0, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), UInt32(rounds), &resultBytes, resultBytes.count)
        }
        return Data(resultBytes)
    }
    
    static func sha256(data: Data, rounds: Int) -> Data {
        var target = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        SHA256.hash(data: data).withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(target.count), &target)
        }
        return Data(target);
    }
    
    static func generate(pwd: String, domain: String) -> String {
        var hash: Data
        do { // fold pwd, then domain, then pwd again
            hash = try UGenPass.hash(data: pwd.data(using: .utf8)!, rounds: ROUNDS)
            hash = try UGenPass.hash(data: hash + domain.data(using: .utf8)!, rounds: ROUNDS)
            hash = try UGenPass.hash(data: hash + pwd.data(using: .utf8)!, rounds: ROUNDS)
        } catch {
            return ""
        }

        var chars = [Character]()
        hash.withUnsafeBytes { (unsafeData: UnsafePointer<CChar>!) in
            chars = TEMPLATE.map { (charset) -> Character in
                         let d = UInt16(charset.count)
                         var r = UInt16(0)
                         for (i, b) in hash.enumerated() {
                             let n = UInt16(b) + r * 256
                             r = n % d
                             hash[i] = UInt8(n / d)
                         }
                         return charset[Int(r)]
            }
        }
        return String(chars)
    }
    
}
