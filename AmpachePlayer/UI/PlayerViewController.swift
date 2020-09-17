import Foundation
import UIKit

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var songTitleLabel: UILabel!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onCurrentSongChanged), name: NSNotification.Name(rawValue: "CurrentSongChanged"), object: nil)
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
            }
        }
    }
}

