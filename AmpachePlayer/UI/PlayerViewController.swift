import AVKit
import Foundation
import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onCurrentSongChanged), name: NSNotification.Name(rawValue: "CurrentSongChanged"), object: nil)
        AudioPlayer.sharedInstance.addObserverForPlayerState(self.playButton)
    }
    
    @objc func onCurrentSongChanged() {
        guard let song = AudioPlayer.sharedInstance.currentSong else { return }
        
        DispatchQueue.main.async {
            self.songTitleLabel.text = song.title
        }
        
        AmpacheManager.sharedInstance.getArt(song: song) { (image: UIImage?) in
            DispatchQueue.main.async {
                let artImage = image == nil ? UIImage.init(named: "blank_album") : image
                self.artImageView.image = artImage
                self.backgroundImageView.image = artImage
            }
        }
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: PlayButton) {
        if sender.playStatus == .paused {
            AudioPlayer.sharedInstance.play()
        } else {
            AudioPlayer.sharedInstance.pause()
        }
    }
}

