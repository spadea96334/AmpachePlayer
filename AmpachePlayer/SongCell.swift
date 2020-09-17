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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
