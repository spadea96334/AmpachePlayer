import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    
    public static let sharedInstance = AudioPlayer.init()
    public var currentSong: SongModel? {
        get {
            return self.currentSongIndex < self.songList.count ? self.songList[self.currentSongIndex] : nil
        }
    }
    
    var songList: [SongModel] = []
    var currentSongIndex = -1
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
    
    public func addSong(song: SongModel) {
        guard let url = URL.init(string: song.url) else { return }
        let item = AVPlayerItem.init(url: url)
        
        if !self.avAudioPlayer.canInsert(item, after: nil) {
            // Todo: show error
        }
        
        self.songList.append(song)
        self.avAudioPlayer.insert(item, after: nil)
        
        // if this is the first song, start playing
        if self.avAudioPlayer.items().count == 1 {
            self.avAudioPlayer.play()
            
            // todo: remove this after ui finish
            self.avAudioPlayer.volume = 0.2
        }
    }
    
    public func removeAllSong() {
        self.avAudioPlayer.pause()
        self.avAudioPlayer.removeAllItems()
        self.currentSongIndex = -1
        self.songList = []
    }
    
    override init() {
        super.init()
        self.avAudioPlayer.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem" {
            self.currentSongIndex += 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentSongChanged"), object: nil)
        }
    }
}
