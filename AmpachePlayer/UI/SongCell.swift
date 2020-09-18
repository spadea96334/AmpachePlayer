import Foundation
import UIKit

class SongCell: UITableViewCell {
    
    public var song: SongModel? {
        didSet {
            self.updateSongInfo()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        self.song = nil
        self.titleLabel.text = ""
    }
    
    func updateSongInfo() {
        if self.song == nil {
            return
        }
        
        self.titleLabel.text = self.song!.title
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: UIButton) {
        guard self.song != nil else { return }
        AudioPlayer.sharedInstance.removeAllSong()
        AudioPlayer.sharedInstance.addSong(song: self.song!)
    }
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        guard self.song != nil else { return }
        AudioPlayer.sharedInstance.addSong(song: self.song!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
