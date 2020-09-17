import Foundation

struct HandshakeModel : Codable {
    var auth: String
    var api: String
    var session_expire: String
    var update: String
    var add: String
    var clean: String
    var songs: Int
    var albums: Int
    var artists: Int
    var playlists: Int
    var videos: Int
    var catalogs: Int
    
    func isEmpty() -> Bool {
        return auth.isEmpty
    }
}
