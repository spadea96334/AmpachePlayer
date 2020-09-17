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
        let data = try? JSONEncoder().encode(self.handshakeModel)
        
        if data != nil {
            UserDefaults.standard.set(data, forKey: "handshake")
            UserDefaults.standard.synchronize()
        } else {
            NSLog("Can't encode handshake model")
        }
    }
    
    func loadLoginInfo() {
        guard let data = UserDefaults.standard.value(forKey: "handshake") as? Data else {return}
        guard let model = try? JSONDecoder().decode(HandshakeModel.self, from: data) else {return}
           
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
