import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadSetting()
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
    
    func loadSetting() {
        self.accountTextField.text = PlayerSetting.sharedInstance.account
        self.serverTextField.text = PlayerSetting.sharedInstance.serverUrl
    }
    
    func login(model: HandshakeModel) {
        let url = PlayerSetting.sharedInstance.serverUrl
        let model = PlayerSetting.sharedInstance.handshakeModel!
        self.changeLoginButton(isLogging: true)
        AmpacheManager.sharedInstance.login(model: model, url: url) { (error: ErrorModel?) in
            self.changeLoginButton(isLogging: false)
            if error != nil {
                // Todo: show error message
                return
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToPlayerSegue", sender: nil)
            }
        }
    }
    
    func changeLoginButton(isLogging: Bool) {
        DispatchQueue.main.async {
            self.loginButton.isEnabled = !isLogging
        }
    }

    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        let model = LoginModel.init()
        model.account = self.accountTextField.text!
        model.password = self.passwordTextField.text!
        model.serverUrl = self.serverTextField.text!
        self.changeLoginButton(isLogging: true)
        AmpacheManager.sharedInstance.login(model: model) { (error: ErrorModel?) in
            self.changeLoginButton(isLogging: false)
            if (error != nil) {
                // Todo: show error message
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "ToPlayerSegue", sender: nil)
            }
            
            guard let handshakeModel = AmpacheManager.sharedInstance.handshakeModel else { return }
            PlayerSetting.sharedInstance.setLoginInfo(model: handshakeModel, url: model.serverUrl)
            PlayerSetting.sharedInstance.setAccount(model.account)
        }
    }
    
}

