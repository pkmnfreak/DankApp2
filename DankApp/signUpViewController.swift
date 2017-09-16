//
//  signUpViewController.swift
//  DankApp
//
//  Created by Evan Chang on 16/09/17.
//  Copyright © 2017 Evan Chang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase


class signUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let databaseRef = Database.database().reference(fromURL: "https://dankapp-55b66.firebaseio.com/")
    let storageRef = Storage.storage().reference()
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordViewController: UITextField!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        guard let usernameTextField = usernameTextField.text else {
            let alert = UIAlertController(title: "Invalid username", message: "Must enter a valid Email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let passwordTextField = passwordTextField.text else {
            let alert = UIAlertController(title: "Invalid password", message: "Your password must be at least 6 characters", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let confirmPasswordField = confirmPasswordViewController.text else {
            
            let alert = UIAlertController(title: "Invalid confirmation!", message: "You have an invalid confirmation.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (confirmPasswordField != passwordTextField) {
            let alert = UIAlertController(title: "Different passwords!", message: "Your passwords do not match", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        Auth.auth().createUser(withEmail: usernameTextField, password: passwordTextField
            , completion: {(user, error) in
                if error != nil {
                    print(error!)
                    return
                }
                guard let uid = user?.uid else {
                    return
                }
                let userReference = self.databaseRef.child("users").child(uid)
                let values : [String : Any] = ["username":usernameTextField, "pic":"", "budget":0, "winstreak":0, "stats":[Int : Any](), "currentRound":0, "compIDs":[String](), "competitionInterval":0, "inComp" : false]
                userReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                self.dismiss(animated: true, completion: nil)
                }
        )})
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControlledImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
