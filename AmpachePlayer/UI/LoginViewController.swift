import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if AmpacheManager.sharedInstance.isLogin {
            self.performSegue(withIdentifier: "ToPlayerSegue", sender: nil)
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
        }
    }
    
}

