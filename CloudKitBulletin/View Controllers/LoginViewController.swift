//
//  ViewController.swift
//  AgnosticBulletin
//
//  Created by Isidore Baldado on 2/7/18.
//  Copyright © 2018 Isidore Baldado. All rights reserved.
//

import UIKit

enum BackendType{
    case Cloudkit
    case Firestore
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    var backendMode = BackendType.Cloudkit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    
    func setupViews(){
        
        for textField in view.subviews.first!.subviews where textField is UITextField  {
            textField.layer.borderWidth = 0.5
            textField.layer.borderColor = UIColor.blue.cgColor
        }
        if segmentedControl.selectedSegmentIndex == 0{
            setupViewsForCloudKit()
        } else {
            setupViewsForFirestore()
        }
    }
    
    func setupViewsForCloudKit(){
        usernameField.isHidden = true
        passwordField.isHidden = true
        signupButton.isHidden = true
        signupButton.setTitle(" ", for: .normal)
        loginButton.setTitle("Enter", for: .normal)
    }
    
    func setupViewsForFirestore(){
        usernameField.isHidden = false
        passwordField.isHidden = false
        signupButton.isHidden = false
        signupButton.setTitle("Signup", for: .normal)
        loginButton.setTitle("Login", for: .normal)
    }
    
    @IBAction func signupPressed(_ sender: Any) {
        guard let username = usernameField.text, !username.isEmpty else {return}
        guard let password = passwordField.text, !password.isEmpty else {return}
        
        // fetchRecords
        // Check info
        // Signup user
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        switch backendMode{

        case .Cloudkit:
            IdentityController.shared.isUserLoggedIn(completion: { (loggedIn) in
                if loggedIn{
                    runOnMain{ self.performSegue(withIdentifier: "loggedIn", sender: nil) }
                } else {
                    self.promptForCloudKitLogin()
                }
            })
            return
            
        case .Firestore:
            guard let username = usernameField.text, !username.isEmpty else {return}
            guard let password = passwordField.text, !password.isEmpty else {return}
            return
        }
    }
    
    fileprivate func promptForCloudKitLogin(){
        let promptAlertController = UIAlertController(title: "iCloud Login Required", message: "Please login to iCloud in your settings", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        promptAlertController.addAction(okAction)
        present(promptAlertController, animated: true, completion: nil)
    }
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        setupViews()
        if segmentedControl.selectedSegmentIndex == 0{
            backendMode = .Cloudkit
        } else{
            backendMode = .Firestore
        }
    }
}

