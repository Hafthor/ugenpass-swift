import Foundation
import CryptoKit
import CommonCrypto

class UGenPass {
    private static let ROUNDS = 65536
    private static let CHARSETS: KeyValuePairs = [
        Character("X"): "ABCDEFGHIJKLMNPQRSTUVWXYZ",
        Character("x"): "abcdefghijkmnopqrstuvwxyz",
        Character("?"): "ABCDEFGHIJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz",
        Character("#"): "23456789",
        Character("!"): "!-()$@."
    ]
    private static let TEMPLATE = "x?#??!X?#??!x?#??!X?#??"
    private static let TEMPLATE_CHARSETS = UGenPass.templateCharsets(template: TEMPLATE, charsets: CHARSETS)

    static func templateCharsets(template: String, charsets: KeyValuePairs<Character, String>) -> [String] {
        return Array(template).map { (t) -> String in
            return charsets.first { $0.key == t }?.value ?? String(t)
        }
    }
    
    static func generate(password: String, domain: String) -> String {
        return generate(password: password, domain: domain, rounds: ROUNDS, template: TEMPLATE_CHARSETS)
    }

    static func generate(password: String, domain: String, rounds: Int) -> String {
        return generate(password: password, domain: domain, rounds: rounds, template: TEMPLATE_CHARSETS)
    }
    
    static func generate(password: String, domain: String, template: [String]) -> String {
        return generate(password: password, domain: domain, rounds: ROUNDS, template: template)
    }
    
    static func generate(password: String, domain: String, template: String, charsets: KeyValuePairs<Character, String>) -> String {
        return generate(password: password, domain: domain, rounds: ROUNDS, template: templateCharsets(template: template, charsets: charsets))
    }
    
    static func generate(password: String, domain: String, rounds: Int, template: String, charsets: KeyValuePairs<Character, String>) -> String {
        return generate(password: password, domain: domain, rounds: rounds, template: templateCharsets(template: template, charsets: charsets))
    }
    
    static func generate(password: String, domain: String, rounds: Int, template: [String]) -> String {
        var hash: Data
        do { // fold pwd, then domain, then pwd again
            hash = try UGenPass.hash(data: password.data(using: .utf8)!, rounds: rounds)
            hash = try UGenPass.hash(data: hash + domain.data(using: .utf8)!, rounds: rounds)
            hash = try UGenPass.hash(data: hash + password.data(using: .utf8)!, rounds: rounds)
        } catch {
            return ""
        }

        var chars = [Character]()
        hash.withUnsafeBytes { (unsafeData: UnsafePointer<CChar>!) in
            chars = template.map { (charsetString) -> Character in
                let charset = Array(charsetString)
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
    
    static func hash(data: Data, rounds: Int) throws -> Data {
        var resultBytes = [UInt8](repeating: 0, count: kCCKeySizeAES256)
        data.withUnsafeBytes { (unsafeData: UnsafePointer<CChar>!) in
            _ = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2), unsafeData, data.count, nil, 0, CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256), UInt32(rounds), &resultBytes, resultBytes.count)
        }
        return Data(resultBytes)
    }
}
