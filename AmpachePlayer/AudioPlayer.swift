import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    
    public static let sharedInstance = AudioPlayer.init()
    public var currentSong: SongModel? {
        get {
            return self.playList?[self.currentSongIndex]
        }
    }
    
    var playList: [SongModel]?
    var currentSongIndex = 0
    var avAudioPlayer = AVQueuePlayer.init()
    
    public func addObserverForPlayerState(_ observer: NSObject){
        self.avAudioPlayer.addObserver(observer, forKeyPath: "timeControlStatus", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    public func play() {
        self.avAudioPlayer.play()
    }
    
    public func pause() {
        self.avAudioPlayer.pause()
    }
    
    public func setSong(index: Int, songList: [SongModel]) {
        self.playList = songList
        self.currentSongIndex = index
        guard let url = URL.init(string: self.playList![index].url) else { return }
        
        self.avAudioPlayer.removeAllItems()
        self.avAudioPlayer.insert(AVPlayerItem.init(url: url), after: nil);
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentSongChanged"), object: nil)
        self.avAudioPlayer.play()
        
        // todo: remove this after ui finish
        self.avAudioPlayer.volume = 0.2
    }
}
