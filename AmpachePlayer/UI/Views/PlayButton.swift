import AVKit
import Foundation
import UIKit

class PlayButton: UIButton {
    
    public var playStatus = AVPlayer.TimeControlStatus.paused {
        didSet {
            self.updateIcon()
        }
    }
    
    func updateIcon() {
        guard self.imageView != nil else { return }
        
        switch self.playStatus {
        case AVPlayer.TimeControlStatus.paused:
            self.imageView!.image = UIImage.init(named: "play_button")
            break
        default:
            self.imageView!.image = UIImage.init(named: "pause_button")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath != nil else { return }
        
        if keyPath == "timeControlStatus" {
            guard change != nil else { return }
            let status = AVPlayer.TimeControlStatus(rawValue: change![NSKeyValueChangeKey.newKey] as! Int)
            self.playStatus = status!
        }
    }
}
