import Foundation

class AmpacheRequestBuilder: NSObject {
    
    private var urlcomponents: URLComponents!
    private var queryItems: [URLQueryItem] = []
    private let apiVersion = "422000"
    
    init(url: String) {
        self.urlcomponents = URLComponents.init(string: url)
        super.init()
        self.urlcomponents.path = "/server/json.server.php"
    }
    
    public func setLoginInfo(model: LoginModel) -> AmpacheRequestBuilder {
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        
        self.queryItems.append(URLQueryItem.init(name: "action", value: "handshake"))
        self.queryItems.append(URLQueryItem.init(name: "user", value: model.account))
        self.queryItems.append(URLQueryItem.init(name: "auth", value: model.getHashPassword(timestamp: timestamp)))
        self.queryItems.append(URLQueryItem.init(name: "timestamp", value: timestamp))
        self.queryItems.append(URLQueryItem.init(name: "version", value: apiVersion))
        
        return self
    }
    
    public func build() -> URLRequest? {
        self.urlcomponents.queryItems = self.queryItems
        guard let url = self.urlcomponents.url else {return nil}
        
        return URLRequest.init(url: url)
    }
}
