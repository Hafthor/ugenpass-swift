import Foundation
import CryptoKit

class SuperGenPass {
    private static let rxValidPassword = try! NSRegularExpression(pattern: "^[a-z].*([0-9].*[A-Z]|[A-Z].*[0-9])", options:[])
    
    static func generate(password: String, domain: String, length: Int) -> String {
        var input = password + ":" + domain, rounds = 0
        let range = NSRange(location: 0, length: length)
        while(rounds<10 || rxValidPassword.rangeOfFirstMatch(in: input, options: [], range: range).location != 0) {
            input = Data(Insecure.MD5.hash(data: input.data(using: .utf8)!))
                .base64EncodedString()
                .replacingOccurrences(of: "+", with: "9")
                .replacingOccurrences(of: "/", with: "8")
                .replacingOccurrences(of: "=", with: "A")
            rounds+=1
        }
        
        return String(input.prefix(length))
    }
}
