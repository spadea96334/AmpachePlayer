import Foundation

struct HandshakeModel : Codable {
    let auth: String
    let api: String
    let session_expire: String
    let update: String
    let add: String
    let clean: String
    let songs: Int
    let albums: Int
    let artists: Int
    let playlists: Int
    let videos: Int
    let catalogs: Int
}
