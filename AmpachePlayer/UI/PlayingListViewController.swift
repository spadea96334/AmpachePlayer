import Foundation
import  UIKit

class PlayingListViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(selectCurrentMedia), name: NSNotification.Name(rawValue: "CurrentMediaChanged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectCurrentMedia()
    }
    
    @objc func selectCurrentMedia() {
        guard AudioPlayer.sharedInstance.mediaList.count != 0 else { return }
        let index = IndexPath.init(row: AudioPlayer.sharedInstance.currentMediaIndex, section: 0)
        self.tableView.selectRow(at: index, animated: true, scrollPosition: .middle)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AudioPlayer.sharedInstance.mediaList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayingCell")
        
        guard let playingCell = cell as? PlayingCell else { return cell! }
        
        playingCell.media = AudioPlayer.sharedInstance.mediaList[indexPath.row]
        
        return playingCell
    }
}
