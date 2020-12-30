import Foundation
import UIKit

class AmpacheManager: NSObject {
    
    public static let sharedInstance = AmpacheManager.init()
    private(set) var handshakeModel: HandshakeModel?
    private(set) var isLogin = false
    private(set) var mediaList: MediaList = []

    var serverUrl: String?
    
    public func ping(completionHandler: @escaping (ErrorModel?) -> Void) {
        let builder = AmpacheRequestBuilder.init(action: .ping, url: self.serverUrl!)
        _ = builder.appendArg(name: "auth", value: self.handshakeModel!.auth)
        guard let request = builder.build() else { return }
        
        NetworkManager.sharedInstance.sendRequest(request: request) { (data:Data?, error:ErrorModel?) in
            completionHandler(error)
        }
    }
    
    public func login(model: HandshakeModel, url: String ,completionHandler: @escaping (ErrorModel?) -> Void) {
        self.handshakeModel = model
        self.serverUrl = url
        
        self.ping { (error: ErrorModel?) in
            if error != nil {
                completionHandler(error)
                return
            }
            
            self.getMediaList { (error: ErrorModel?) in
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
        guard let request = requestBuilder.build() else { return }
        
        NetworkManager.sharedInstance.sendRequest(request: request) { (data:Data?, error:ErrorModel?) in
            if error != nil {
                completionHandler(error)
                return
            }
            
            let handshakeModel = try? JSONDecoder.init().decode(HandshakeModel.self, from: data!)
            if handshakeModel == nil {
                let errorMessage = "Can't parse login response"
                let responseError = ErrorModel.init(error: ErrorMessage.init(code: "-100", message: errorMessage))
                completionHandler(responseError)
                return
            }
            
            self.isLogin = true
            self.handshakeModel = handshakeModel
            self.getMediaList { (error: ErrorModel?) in
                completionHandler(nil)
            }
        }
    }
    
    public func getArt(media: MediaModel, completionHandler: @escaping (UIImage?) -> Void) {
        guard let artUrl = URL.init(string: media.art) else { return }
        let request = URLRequest.init(url: artUrl)
        
        NetworkManager.sharedInstance.sendRequest(request: request) { (data:Data?, error:ErrorModel?) in
            if error != nil {
                completionHandler(nil)
                return
            }
            
            completionHandler(UIImage.init(data: data!))
        }
    }
    
    func getMediaList(completionHandler: @escaping (ErrorModel?) -> Void) {
        let requestBuilder = AmpacheRequestBuilder.init(action: .getIndexes, url: self.serverUrl!)
        _ = requestBuilder.appendArg(name: "type", value: "song").appendArg(name: "auth", value: self.handshakeModel!.auth)
        guard let request = requestBuilder.build() else { return }
        
        NetworkManager.sharedInstance.sendRequest(request: request) { (data:Data?, error:ErrorModel?) in
            if error != nil {
                completionHandler(error)
                return
            }
            
            var mediaList: MediaList?
            do {
                mediaList = try JSONDecoder.init().decode(MediaList.self, from: data!)
            } catch {
                NSLog("Error parse media info: " + error.localizedDescription)
            }
            
            if mediaList == nil {
                let errorMessage = "Can't parse mediaList response"
                let responseError = ErrorModel.init(error: ErrorMessage.init(code: "-100", message: errorMessage))
                completionHandler(responseError)
                return
            }
            
            self.mediaList = mediaList!
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "MediaListChanged"), object: nil)
            completionHandler(nil)
        }
    }
    
    private override init() {
        super.init()
    }
}
