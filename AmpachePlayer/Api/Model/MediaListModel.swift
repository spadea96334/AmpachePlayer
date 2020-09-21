import Foundation

typealias MediaList = [MediaModel]

struct MediaModel: Codable {
    let id, title, name: String
    let artist, album: Album
    let tag: [Album]
    let filename: String
    let track, playlisttrack, time, year: Int
    let bitrate, rate: Int
    let mode: String?
    let mime: String
    let url: String
    let size: Int
    let mbid: String?
    let albumMbid, artistMbid, albumartistMbid: String?
    let art: String
    let flag: Int
    let preciserating, rating: Int?
    let averagerating: Int?
    let playcount, catalog: Int
    let composer: String
    let channels: Int?
    let comment, publisher, language, replaygainAlbumGain: String
    let replaygainAlbumPeak, replaygainTrackGain, replaygainTrackPeak: String
    let genre: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, title, name, artist, album, tag, filename, track, playlisttrack, time, year, bitrate, rate, mode, mime, url, size, mbid
        case albumMbid = "album_mbid"
        case artistMbid = "artist_mbid"
        case albumartistMbid = "albumartist_mbid"
        case art, flag, preciserating, rating, averagerating, playcount, catalog, composer, channels, comment, publisher, language
        case replaygainAlbumGain = "replaygain_album_gain"
        case replaygainAlbumPeak = "replaygain_album_peak"
        case replaygainTrackGain = "replaygain_track_gain"
        case replaygainTrackPeak = "replaygain_track_peak"
        case genre
    }
}

struct Album: Codable {
    let id, name: String
}

struct Genre: Codable {
    let name: String
}
