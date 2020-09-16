import Foundation

struct ErrorModel : Codable {
    let error: ErrorMessage
}

struct ErrorMessage : Codable {
    let code: String
    let message: String
}
