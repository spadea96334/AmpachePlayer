import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    
    public static let sharedInstance = AudioPlayer.init()
    public var currentMedia: MediaModel? {
        get {
            return self.currentMediaIndex > -1 && self.currentMediaIndex < self.mediaList.count ? self.mediaList[self.currentMediaIndex] : nil
        }
    }
    private(set) var mediaList: [MediaModel] = []
    
    let QUEUE_LENGTH = 2
    var currentMediaIndex = -1
    var avAudioPlayer = AVQueuePlayer.init()
    var isFilling = false

    public func addObserverForPlayerState(_ observer: NSObject){
        self.avAudioPlayer.addObserver(observer, forKeyPath: "timeControlStatus", options: .new, context: nil)
    }
    
    public func play() {
        self.avAudioPlayer.play()
    }
    
    public func pause() {
        self.avAudioPlayer.pause()
    }
    
    public func next() {
        if currentMediaIndex == self.mediaList.count - 1 {
            return
        }
        
        self.avAudioPlayer.advanceToNextItem()
    }
    
    public func previous() {
        if self.avAudioPlayer.items().count == 0 || self.currentMediaIndex <= 0 {
            return
        }
        
        self.avAudioPlayer.pause()
        self.currentMediaIndex -= 2
        
        for i in 1..<self.avAudioPlayer.items().count {
            self.avAudioPlayer.remove(self.avAudioPlayer.items()[i])
        }
        
        guard let mediaUrl = URL.init(string: self.mediaList[self.currentMediaIndex + 1].url) else { return }
        self.avAudioPlayer.replaceCurrentItem(with: AVPlayerItem.init(url: mediaUrl))
        self.avAudioPlayer.play()
    }
    
    public func addMedia(mediaList: [MediaModel]) {
        self.mediaList += mediaList
        
        _ = self.fillItemToAudioPlayer()
        
        // If there is no playing media now, start playing
        if self.avAudioPlayer.items().count != 0 && self.avAudioPlayer.timeControlStatus != .playing {
            self.avAudioPlayer.play()
            // todo: remove this after ui finish
            self.avAudioPlayer.volume = 0.2
        }
    }
    
    public func addMedia(media: MediaModel) {
        self.mediaList.append(media)
        
        _ = self.fillItemToAudioPlayer()
        
        // If there is no playing media now, start playing
        if self.avAudioPlayer.items().count != 0 && self.avAudioPlayer.timeControlStatus != .playing {
            self.avAudioPlayer.play()
            // todo: remove this after ui finish
            self.avAudioPlayer.volume = 0.2
        }
    }
    
    public func removeAllMedia() {
        self.mediaList = []
        self.currentMediaIndex = -1
        self.avAudioPlayer.pause()
        self.avAudioPlayer.removeAllItems()
    }
    
    func fillItemToAudioPlayer() -> Bool {
        // is last media
        if self.isFilling {
            return false
        }
        
        guard self.currentMediaIndex < self.mediaList.count - 1 else {
            return false
        }
        
        // queue is full
        if self.avAudioPlayer.items().count >= QUEUE_LENGTH {
            return false
        }
        
        self.isFilling = true
        let needFillLength = QUEUE_LENGTH - self.avAudioPlayer.items().count
        let remainMedia = self.mediaList.count - self.currentMediaIndex - 1
        // Append media until avplayer's item count equal to QUEUE_LENGTH or no media
        for i in self.currentMediaIndex + 1...self.currentMediaIndex + min(needFillLength, remainMedia) {
            let mediaModel = self.mediaList[i]
            guard let mediaUrl = URL.init(string: mediaModel.url) else { return false }
            let item = AVPlayerItem.init(url: mediaUrl)
            
            guard self.avAudioPlayer.canInsert(item, after: nil) else {
                self.isFilling = false
                return false
            }
            
            self.avAudioPlayer.insert(item, after: nil)
        }
        
        self.isFilling = false

        return true
    }
    
    func onCurrentItemChanged() {
        let mediaItems = self.avAudioPlayer.items()
        if mediaItems.count < QUEUE_LENGTH {
            if self.currentMediaIndex + 1 < self.mediaList.count {
                self.currentMediaIndex += 1
            }
            
            _ = self.fillItemToAudioPlayer()
        }
    }
    
    override init() {
        super.init()
        self.avAudioPlayer.addObserver(self, forKeyPath: "currentItem", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem" {
            self.onCurrentItemChanged()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentMediaChanged"), object: nil)
        }
    }
}
