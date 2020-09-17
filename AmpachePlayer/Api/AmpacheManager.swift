import Foundation

class AmpacheManager: NSObject {
    
    public static let sharedInstance = AmpacheManager.init()
    private(set) var isLogin = false
    var songCount: Int {
        get{
            return (self.handshakeModel == nil) ? 0 : self.handshakeModel!.songs
        }
    }
    
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
    
    func saveLoginInfo() {
        UserDefaults.standard.set(self.handshakeModel?.auth, forKey: "auth")
        UserDefaults.standard.set(self.handshakeModel?.api, forKey: "api")
        UserDefaults.standard.set(self.handshakeModel?.session_expire, forKey: "session_expire")
        UserDefaults.standard.set(self.handshakeModel?.update, forKey: "update")
        UserDefaults.standard.set(self.handshakeModel?.clean, forKey: "clean")
        UserDefaults.standard.set(self.handshakeModel?.songs, forKey: "songs")
        UserDefaults.standard.set(self.handshakeModel?.albums, forKey: "albums")
        UserDefaults.standard.set(self.handshakeModel?.artists, forKey: "artists")
        UserDefaults.standard.set(self.handshakeModel?.playlists, forKey: "playlists")
        UserDefaults.standard.set(self.handshakeModel?.videos, forKey: "videos")
        UserDefaults.standard.set(self.handshakeModel?.catalogs, forKey: "catalogs")
        
        UserDefaults.standard.synchronize()
    }
    
    func loadLoginInfo() {
        var model: HandshakeModel = HandshakeModel.init(auth: "", api: "", session_expire: "", update: "", add: "", clean: "", songs: 0, albums: 0, artists: 0, playlists: 0, videos: 0, catalogs: 0)
        model.auth =  UserDefaults.standard.value(forKey: "api") as! String
        model.api =  UserDefaults.standard.value(forKey: "auth") as! String
        model.session_expire =  UserDefaults.standard.value(forKey: "session_expire") as! String
        model.update =  UserDefaults.standard.value(forKey: "update") as! String
        model.clean =  UserDefaults.standard.value(forKey: "clean") as! String
        model.songs =  UserDefaults.standard.value(forKey: "songs") as! Int
        model.albums =  UserDefaults.standard.value(forKey: "albums") as! Int
        model.artists =  UserDefaults.standard.value(forKey: "artists") as! Int
        model.playlists =  UserDefaults.standard.value(forKey: "playlists") as! Int
        model.videos =  UserDefaults.standard.value(forKey: "videos") as! Int
        model.catalogs =  UserDefaults.standard.value(forKey: "catalogs") as! Int
        
        if !model.isEmpty() {
            self.isLogin = true
            self.handshakeModel = model
        }
    }
    
    private override init() {
        super.init()
        self.loadLoginInfo()
    }
}
