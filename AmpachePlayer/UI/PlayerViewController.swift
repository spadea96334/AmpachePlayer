import AVKit
import Foundation
import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onCurrentMediaChanged), name: NSNotification.Name(rawValue: "CurrentMediaChanged"), object: nil)
        AudioPlayer.sharedInstance.addObserverForPlayerState(self.playButton)
    }
    
    @objc func onCurrentMediaChanged() {
        guard let media = AudioPlayer.sharedInstance.currentMedia else { return }
        
        DispatchQueue.main.async {
            self.mediaTitleLabel.text = media.title
        }
        
        AmpacheManager.sharedInstance.getArt(media: media) { (image: UIImage?) in
            DispatchQueue.main.async {
                let artImage = image == nil ? UIImage.init(named: "blank_album") : image
                self.artImageView.image = artImage
                self.backgroundImageView.image = artImage
            }
        }
    }
    
    // MARK: - Button Event
    @IBAction func playButtonTouchUpInside(_ sender: PlayButton) {
        if sender.playStatus == .paused {
            AudioPlayer.sharedInstance.play()
        } else {
            AudioPlayer.sharedInstance.pause()
        }
    }
    
    @IBAction func nextButtonTouchUpInside() {
        AudioPlayer.sharedInstance.next()
    }
    
}

