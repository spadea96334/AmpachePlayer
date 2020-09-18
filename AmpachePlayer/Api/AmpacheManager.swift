import Foundation
import UIKit

class AmpacheManager: NSObject {
    
    public static let sharedInstance = AmpacheManager.init()
    private(set) var handshakeModel: HandshakeModel?
    private(set) var isLogin = false
    private(set) var songList: SongList = []

    let session = URLSession.init(configuration: URLSessionConfiguration.default)
    var serverUrl: String?
    
    public func ping(completionHandler: @escaping (ErrorModel?) -> Void) {
        let builder = AmpacheRequestBuilder.init(action: .ping, url: self.serverUrl!)
        _ = builder.appendArg(name: "auth", value: self.handshakeModel!.auth)
        guard let request = builder.build() else { return }
        
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if error != nil || data == nil {
                return
            }
            
            let errorModel = try? JSONDecoder.init().decode(ErrorModel.self, from: data!)
            
            if errorModel != nil {
                completionHandler(errorModel)
                return
            }
            
            completionHandler(nil)
        }
        
        dataTask.resume()
    }
    
    public func login(model: HandshakeModel, url: String ,completionHandler: @escaping (ErrorModel?) -> Void) {
        self.handshakeModel = model
        self.serverUrl = url
        
        self.ping { (error: ErrorModel?) in
            if error != nil {
                completionHandler(error)
                return
            }
            
            self.getSongList { (error: ErrorModel?) in
                if error != nil {
                    completionHandler(error)
                    return
                }
                
                completionHandler(nil)
            }
        }
    }
    
    public func login(model: LoginModel) {
        self.login(model: model, completionHandler:{_ in })
    }
    
    public func login(model: LoginModel, completionHandler: @escaping (ErrorModel?) -> Void) {
        self.serverUrl = model.serverUrl
        let requestBuilder = AmpacheRequestBuilder.init(action: .handshake, url: self.serverUrl!)
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
                self.getSongList { (error: ErrorModel?) in
                    completionHandler(nil)
                }
                
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
    
    func getSongList(completionHandler: @escaping (ErrorModel?) -> Void) {
        let requestBuilder = AmpacheRequestBuilder.init(action: .getIndexes, url: self.serverUrl!)
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
                completionHandler(nil)
                
                return
            }
            
            let errorModel = try? JSONDecoder.init().decode(ErrorModel.self, from: data!)
            
            if errorModel != nil {
                print(errorModel!.error.message)
                completionHandler(errorModel)
                return
            }
        }
        
        dataTask.resume()
    }
    
    private override init() {
        super.init()
    }
}
