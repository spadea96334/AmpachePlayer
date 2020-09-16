import Foundation

import CryptoKit
 
class LoginModel: NSObject {
    
    public var account: String = ""
    public var password: String = "" {
        didSet {
            self.password = sha256(self.password)
        }
    }
    public var serverUrl: String = ""
    
    func sha256(_ content: String) -> String {
        return SHA256.hash(data: Data(content.utf8)).compactMap {String(format: "%02x", $0)}.joined()
    }
    
    public func getHashPassword(timestamp: String) -> String {
        return sha256(timestamp + self.password)
    }
}
