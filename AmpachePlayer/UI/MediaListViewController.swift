import Foundation
import UIKit

class MediaListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mediaTableView: UITableView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onMediaListChanged), name: NSNotification.Name(rawValue: "MediaListChanged"), object: nil)
    }
    
    @objc func onMediaListChanged() {
        DispatchQueue.main.async {
            self.mediaTableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AmpacheManager.sharedInstance.mediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell")!
        
        if let mediaCell = cell as? MediaCell {
            mediaCell.media = AmpacheManager.sharedInstance.mediaList[indexPath.row]
        }
        
        return cell
    }
}
