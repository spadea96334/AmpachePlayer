import Foundation

class PlayerSetting: NSObject {
    
    public static let sharedInstance = PlayerSetting.init()
    private(set) var account = ""
    private(set) var serverUrl = "https://"
    private(set) var handshakeModel: HandshakeModel?
    
    func setLoginInfo(model: HandshakeModel, url: String) {
        self.serverUrl = url
        self.handshakeModel = model
        let data = try? JSONEncoder().encode(self.handshakeModel)
        
        if data == nil {
            NSLog("Can't encode handshake model")
            return
        }
        
        UserDefaults.standard.set(data, forKey: "handshake")
        UserDefaults.standard.set(self.serverUrl, forKey: "serverUrl")
        UserDefaults.standard.synchronize()
    }
    
    func setAccount(_ account: String) {
        self.account = account
        UserDefaults.standard.set(account, forKey: "account")
        UserDefaults.standard.synchronize()
    }
    
    func loadSetting() {
        guard let data = UserDefaults.standard.value(forKey: "handshake") as? Data else { return }
        guard let model = try? JSONDecoder().decode(HandshakeModel.self, from: data) else { return }
        guard let serverUrl = UserDefaults.standard.value(forKey: "serverUrl") as? String else { return }
        guard let account = UserDefaults.standard.value(forKey: "account") as? String else { return }
        self.account = account
        self.serverUrl = serverUrl

        if !model.isEmpty() {
            self.handshakeModel = model
            
            return
        }
    }
    
    private override init() {
        super.init()
        self.loadSetting()
    }
}
