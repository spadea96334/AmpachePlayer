import AVFoundation
import Foundation

class AudioPlayer: NSObject {
    
    public static let sharedInstance = AudioPlayer.init()
    public var currentMedia: MediaModel? {
        get {
            return self.currentMediaIndex < self.mediaList.count ? self.mediaList[self.currentMediaIndex] : nil
        }
    }
    private(set) var mediaList: [MediaModel] = []
    
    var currentMediaIndex = -1
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
    
    public func next() {
        if currentMediaIndex == self.mediaList.count - 1 {
            return
        }
        
        self.avAudioPlayer.advanceToNextItem()
    }
    
    public func addMedia(mediaList: [MediaModel]) {
        // Temporarily disable this function ,because AVQueuePlayer stuck when adding a lot of item
        // Todo: Implement a queue to replace queue of AVQueuePlayer
        return
        for media in mediaList {
            guard let url = URL.init(string: media.url) else { continue }
            let item = AVPlayerItem.init(url: url)
            
            if !self.avAudioPlayer.canInsert(item, after: nil) {
                // Todo: show error
            }
            
            self.mediaList.append(media)
            self.avAudioPlayer.insert(item, after: nil)
        }
        
        // if this is the first media, start playing
        if self.avAudioPlayer.items().count == 1 {
            self.avAudioPlayer.play()
            
            // todo: remove this after ui finish
            self.avAudioPlayer.volume = 0.2
        }
    }
    
    public func addMedia(media: MediaModel) {
        guard let url = URL.init(string: media.url) else { return }
        let item = AVPlayerItem.init(url: url)
        
        if !self.avAudioPlayer.canInsert(item, after: nil) {
            // Todo: show error
        }
        
        self.mediaList.append(media)
        self.avAudioPlayer.insert(item, after: nil)
        
        // if this is the first media, start playing
        if self.avAudioPlayer.items().count == 1 {
            self.avAudioPlayer.play()
            
            // todo: remove this after ui finish
            self.avAudioPlayer.volume = 0.2
        }
    }
    
    public func removeAllMedia() {
        self.avAudioPlayer.pause()
        self.avAudioPlayer.removeAllItems()
        self.currentMediaIndex = -1
        self.mediaList = []
    }
    
    override init() {
        super.init()
        self.avAudioPlayer.addObserver(self, forKeyPath: "currentItem", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem" {
            guard self.currentMediaIndex != self.mediaList.count - 1 else { return }
            self.currentMediaIndex += 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentMediaChanged"), object: nil)
        }
    }
}
