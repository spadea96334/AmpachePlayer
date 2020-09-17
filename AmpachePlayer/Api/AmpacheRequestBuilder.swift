import Foundation

class AmpacheRequestBuilder: NSObject {
    
    public enum Action: String {
        case handshake = "handshake"
        case getIndexes = "get_indexes"
    }
    
    private var urlcomponents: URLComponents!
    private var queryItems: [URLQueryItem] = []
    private let apiVersion = "422000"
    
    init(action: Action, url: String) {
        self.urlcomponents = URLComponents.init(string: url)
        super.init()
        self.urlcomponents.path = "/server/json.server.php"
        self.queryItems.append(URLQueryItem.init(name: "action", value: action.rawValue))
    }
    
    public func appendArg(name: String, value: String) -> AmpacheRequestBuilder {
        self.queryItems.append(URLQueryItem.init(name: name, value: value))
        
        return self
    }
    
    public func setLoginInfo(model: LoginModel) -> AmpacheRequestBuilder {
        let timestamp = "\(Int(Date().timeIntervalSince1970))"
        
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
