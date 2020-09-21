import Foundation
import UIKit

class PlayingCell: UITableViewCell {
    
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
