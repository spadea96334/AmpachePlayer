import Foundation
import UIKit

class AmpacheManager: NSObject {
    
    public static let sharedInstance = AmpacheManager.init()
    private(set) var songList: SongList = []
    private(set) var isLogin = false

    let session = URLSession.init(configuration: URLSessionConfiguration.default)
    var serverUrl: String?
    var handshakeModel: HandshakeModel?
    
    public func login(model: LoginModel) {
        self.login(model: model, completionHandler:{_ in })
    }
    
    public func login(model: LoginModel, completionHandler: @escaping (ErrorModel?) -> Void) {
        self.serverUrl = model.serverUrl
        let requestBuilder = AmpacheRequestBuilder.init(action: AmpacheRequestBuilder.Action.handshake, url: self.serverUrl!)
        _ = requestBuilder.setLoginInfo(model: model)
        guard let request = requestBuilder.build() else {return}
        
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if error != nil || data == nil {
                return
            }
            
            let handshakeModel = try? JSONDecoder.init().decode(HandshakeModel.self, from: data!)
            
            if handshakeModel != nil {
                self.isLogin = true
                self.handshakeModel = handshakeModel
                completionHandler(nil)
                self.saveLoginInfo()
                
                return
            }
            
            let errorModel = try? JSONDecoder.init().decode(ErrorModel.self, from: data!)
            
            if errorModel != nil {
                completionHandler(errorModel)
                return
            }
            
            print("No expect condition in login process")
        }
        
        dataTask.resume()
    }
    
    public func getArt(song: SongModel, completionHandler: @escaping (UIImage?) -> Void) {
        guard let artUrl = URL.init(string: song.art) else { return }
        
        let dataTask = self.session.dataTask(with: artUrl) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil || data == nil {
                completionHandler(nil)
            }
            
            completionHandler(UIImage.init(data: data!))
        }
        
        dataTask.resume()
    }
    
    func getSongList() {
        let requestBuilder = AmpacheRequestBuilder.init(action: AmpacheRequestBuilder.Action.getIndexes, url: self.serverUrl!)
        _ = requestBuilder.appendArg(name: "type", value: "song").appendArg(name: "auth", value: self.handshakeModel!.auth)
        guard let request = requestBuilder.build() else {return}
        
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if error != nil || data == nil {
                return
            }
           
            var songList: SongList?
            do {
                songList = try JSONDecoder.init().decode(SongList.self, from: data!)
            } catch {
                NSLog("Error parse song info: " + error.localizedDescription)
            }
            
            if songList != nil {
                self.songList = songList!
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SongListChanged"), object: nil)
                
                return
            }
            
            let errorModel = try? JSONDecoder.init().decode(ErrorModel.self, from: data!)
            
            if errorModel != nil {
                print(errorModel!.error.message)
                return
            }
        }
        
        dataTask.resume()
    }
    
    func saveLoginInfo() {
        let data = try? JSONEncoder().encode(self.handshakeModel)
        
        if data != nil {
            UserDefaults.standard.set(data, forKey: "handshake")
        } else {
            NSLog("Can't encode handshake model")
            return
        }
        
        UserDefaults.standard.set(self.serverUrl!, forKey: "serverUrl")
        UserDefaults.standard.synchronize()
    }
    
    func loadLastLogin() -> Bool {
        guard let data = UserDefaults.standard.value(forKey: "handshake") as? Data else {return false}
        guard let model = try? JSONDecoder().decode(HandshakeModel.self, from: data) else {return false}
        guard let serverUrl = UserDefaults.standard.value(forKey: "serverUrl") as? String else {return false}
        self.serverUrl = serverUrl
           
        if !model.isEmpty() {
            self.isLogin = true
            self.handshakeModel = model
            
            return true
        }
        
        return false
    }
    
    private override init() {
        super.init()
        if self.loadLastLogin() {
            self.getSongList()
        }
    }
}
