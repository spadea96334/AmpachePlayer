import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if PlayerSetting.sharedInstance.handshakeModel != nil {
            self.login(model: PlayerSetting.sharedInstance.handshakeModel!)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AmpacheManager.sharedInstance.isLogin {
            self.performSegue(withIdentifier: "ToPlayerSegue", sender: nil)
        }
    }
    
    func login(model: HandshakeModel) {
        guard let url = PlayerSetting.sharedInstance.serverUrl else { return }
        let model = PlayerSetting.sharedInstance.handshakeModel!
        AmpacheManager.sharedInstance.login(model: model, url: url) { (error: ErrorModel?) in
            if error != nil {
                // Todo: show error message
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToPlayerSegue", sender: nil)
            }
        }
    }

    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        let model = LoginModel.init()
        model.account = self.accountTextField.text!
        model.password = self.passwordTextField.text!
        model.serverUrl = self.serverTextField.text!
        AmpacheManager.sharedInstance.login(model: model) { (error: ErrorModel?) in
            if (error != nil) {
                // Todo: show error message
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToPlayerSegue", sender: nil)
            }
            
            guard let handshakeModel = AmpacheManager.sharedInstance.handshakeModel else { return }
            PlayerSetting.sharedInstance.saveLoginInfo(model: handshakeModel, url: model.serverUrl)
        }
    }
    
}

