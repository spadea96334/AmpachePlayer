import Foundation

class NetworkManager: NSObject {
    
    public static let sharedInstance = NetworkManager.init()
    let session = URLSession.init(configuration: URLSessionConfiguration.default)
    
    // Ensure data not nil when no error occur.
    public func sendRequest(request: URLRequest, completionHandler: @escaping (Data?, ErrorModel?) -> Void) {
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            let httpResponse = response as! HTTPURLResponse
            if error != nil {
                let errorModel = ErrorModel.init(error: ErrorMessage.init(code: "\(httpResponse.statusCode)", message: error!.localizedDescription))
                completionHandler(nil, errorModel)
                return
            }
            
            // check response conetent not a error message
            let errorModel = try? JSONDecoder.init().decode(ErrorModel.self, from: data!)
            if errorModel != nil {
                completionHandler(nil, errorModel)
                return
            }
            
            completionHandler(data, nil)
        }
        
        dataTask.resume()
    }
    
    private override init() {
        super.init()
    }
}
