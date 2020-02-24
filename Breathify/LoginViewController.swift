//
//  LoginViewController.swift
//  Breathify
//
//  Created by Keith Chan on 2017-03-19.
//  Copyright © 2017 Group Nein. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    var user : UserProfile = UserProfile()
    var updatedUser: UserProfile?
    
    // MARK: Outlets
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    
    // MARK: Actions
    
    
    @IBAction func Login(_ sender: Any) {
        
        FIRAuth.auth()?.signIn(withEmail: self.emailField.text!, password: self.passwordField.text!) { (user, error) in
            
            if error == nil {
                
                //Print into the console if successfully logged in
                print("You have successfully logged in")
                
                self.user.email = self.emailField.text!
                self.user.password = self.passwordField.text!
                
                self.performSegue(withIdentifier: "Home", sender: nil)
                
            } else {
                
                //Tells the user that there is an error and then gets firebase to tell them the error
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }

    
    @IBAction func ForgotPassword(_ sender: Any) {
        
        let alert = UIAlertController(title: "Forgot Password?", message: "", preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { action in
            
            let emailField = alert.textFields![0]
            
            if emailField.text! == "" {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
                    
                    // initialize title and message
                    var title = ""
                    var message = ""
                    
                    // implement title and message depending on if there is an error
                    if error != nil {
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        title = "Success!"
                        message = "Password reset email sent."
                    }
                    
                    // send out message on whether password reset is successful
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        
        present(alert, animated:true, completion:nil)
    }
    
    // Sets the colour font of the status bar to be white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        LoginButton.isEnabled = false
    }
    
    // Exit software Keyboard when user presses Done form the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateButtonStatus()
    }
    
    // Exit the software keyboard if the user touches the view that is not the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.delegate = self
        passwordField.delegate = self
        
        // Do any additional setup after loading the view.
        emailField.text = user.email
        passwordField.text = user.password
        
        updateButtonStatus()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Home" {
            updatedUser = user
        }
    }
    
    // MARK: Private Methods
    
    private func updateButtonStatus() {
        
        let text = emailField.text ?? ""
        let text2 = passwordField.text ?? ""
        
        LoginButton.isEnabled = (!text.isEmpty && !text2.isEmpty)
    }
}
