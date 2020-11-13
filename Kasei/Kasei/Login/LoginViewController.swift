//
//  LoginViewController.swift
//  Kasei
//
//  Created by Eugene L. on 11/11/20.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: View Objects
    
    @IBOutlet weak var emailContainer: UIView!
    @IBOutlet weak var emailFld: UITextField!
    @IBOutlet weak var emailLine: UIView!
    
    @IBOutlet weak var pwContainer: UIView!
    @IBOutlet weak var pwFld: UITextField!
    @IBOutlet weak var pwLine: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInBtn: MNButton!
    
    //MARK: Variables
    
    var emailField: LoginField?
    var pwField: LoginField?
    let firAuth = Auth.auth()
    
    //MARK: Delegate methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailFld.delegate = self
        pwFld.delegate = self
        
        emailField = LoginField(container: emailContainer, textfield: emailFld, accentLine: emailLine)
        pwField = LoginField(container: pwContainer, textfield: pwFld, accentLine: pwLine)
        
        // Start view with focus on emailLine
        emailFld.becomeFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        gotoNextFieldFor(textField: textField)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateFieldsOnEdit(textField)
        if let lf = getLoginFieldFor(textField: textField) {
            lf.accentLine.backgroundColor = UIColor(named: "Accent Static")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let lf = getLoginFieldFor(textField: textField) {
            lf.accentLine.backgroundColor = UIColor(named: "Textfield Accent")
        }
    }
    
    @IBAction func clickedSignIn(_ sender: Any) {
        signInBtn.coloriseWithAccent(enabled: false)
        signIn()
    }
    
    @IBAction func tapOutOfKeyboard(_ sender: Any) {
        signInBtn.coloriseWithAccent(enabled: false)
        self.view.endEditing(true)
    }
    
    //MARK: Class Functions
    
    func gotoNextFieldFor(textField: UITextField) {
        switch textField {
        case emailFld:
            pwFld.becomeFirstResponder()
        default:
            pwFld.resignFirstResponder()
            signInBtn.coloriseWithAccent(enabled: true)
        }
    }
    
    func getLoginFieldFor(textField: UITextField) -> LoginField? {
        switch textField {
        case emailField?.textfield:
            return emailField
        case pwField?.textfield:
            return pwField
        default:
            return nil
        }
    }
    
    func updateFieldsOnEdit(_ textField: UITextField) {
        if let lf = getLoginFieldFor(textField: textField) {
            if(lf.hasError) {
                dismissErrors()
            }
        }
        
        // Update Sign In Btn
        signInBtn.coloriseWithAccent(enabled: false)
        if !signInBtn.isEnabled {
            signInBtn.isEnabled = true
        }
    }
    
    func dismissErrors() {
        errorLabel.text = ""
        emailField?.dismissError()
        pwField?.dismissError()
    }
    
    func signIn() {
        let email = emailFld.text ?? ""
        let pw = pwFld.text ?? ""
        
            firAuth.signIn(withEmail: email, password: pw) { (user, error) in
            if let error = error as NSError? {
                if let err = AuthErrorCode(rawValue: error.code) {
                    self.handleAuthError(err)
                }
            } else {
                self.finishSignIn()
            }
        }
    }
    
    func handleAuthError(_ code: AuthErrorCode) {
        signInBtn.isEnabled = false
        switch code {
        case .invalidEmail:
            errorLabel.text = "This is not an email!"
            emailField?.displayError()
        case .missingEmail:
            errorLabel.text = "No email found!"
            emailField?.displayError()
        case .wrongPassword, .userNotFound:
            errorLabel.text = "Wrong email or password!"
            emailField?.displayError()
            pwField?.displayError()
        default:
            errorLabel.text = "An unknown error occured. Please try again later."
            emailField?.displayError()
            pwField?.displayError()
        }
    }
    
    func finishSignIn() {
        self.navigationController?.dismiss(animated: true) {
            //code
        }
    }

}
