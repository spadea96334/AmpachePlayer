import Foundation
import UIKit

class SongCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public func setTitle(title: String) {
        self.titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
