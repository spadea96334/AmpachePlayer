import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    
    public static let sharedInstance = AudioPlayer.init()
    public var currentSong: SongModel? {
        get {
            return self.songModel
        }
    }
    
    var avAudioPlayer: AVPlayer?
    var songModel: SongModel?
    
    public func setSong(song: SongModel) {
        self.songModel = song
        guard let url = URL.init(string: self.songModel!.url) else { return }
        
        self.avAudioPlayer = AVPlayer.init(url: url)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentSongChanged"), object: nil)
        self.avAudioPlayer!.play()
        
        // todo: remove this after ui finish
        self.avAudioPlayer?.volume = 0.2
    }
}
