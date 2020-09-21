import Foundation
import UIKit

class MediaCell: UITableViewCell {
    
    public var media: MediaModel? {
        didSet {
            self.updateMediaInfo()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        self.media = nil
        self.titleLabel.text = ""
    }
    
    func updateMediaInfo() {
        if self.media == nil {
            return
        }
        
        self.titleLabel.text = self.media!.title
    }
    
    @IBAction func playButtonTouchUpInside(_ sender: UIButton) {
        guard self.media != nil else { return }
        AudioPlayer.sharedInstance.removeAllMedia()
        AudioPlayer.sharedInstance.addMedia(media: self.media!)
    }
    
    @IBAction func addButtonTouchUpInside(_ sender: UIButton) {
        guard self.media != nil else { return }
        AudioPlayer.sharedInstance.addMedia(media: self.media!)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
