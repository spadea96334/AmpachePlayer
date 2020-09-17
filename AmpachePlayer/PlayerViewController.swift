import Foundation
import UIKit

class PlayerViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var SongTableView: UITableView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(onSongListChanged), name: NSNotification.Name(rawValue: "SongListChanged"), object: nil)
    }
    
    @objc func onSongListChanged() {
        DispatchQueue.main.async {
            self.SongTableView.reloadData()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AmpacheManager.sharedInstance.songList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell")!
        
        if let songCell = cell as? SongCell {
            songCell.setTitle(title: AmpacheManager.sharedInstance.songList[indexPath.row].title)
        }
        
        return cell
    }
}
