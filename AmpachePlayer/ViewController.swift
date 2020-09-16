import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var serverTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButtonTouchUpInside(_ sender: Any) {
        let model = LoginModel.init()
        model.account = self.accountTextField.text!
        model.password = self.passwordTextField.text!
        model.serverUrl = self.serverTextField.text!
        AmpacheManager.sharedInstance.login(model: model)
    }
    
}

