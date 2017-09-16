//
//  transactionViewController.swift
//  DankApp
//
//  Created by Evan Chang on 16/09/17.
//  Copyright © 2017 Evan Chang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class transactionViewController: UIViewController {
    
    let types = ["Food", "Transportation", "Recreational"]
    let databaseRef = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var currentRound = ""
    var currentDate = ""
    
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var typeOfTransaction: UISegmentedControl!
    
    @IBOutlet weak var commentsTextField: UITextView!
    
    override func viewDidLoad() {
        fetchData { (value) in
            self.currentRound = String(value)
        }
        let date = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        currentDate = String(describing: dateComponents.month) + "-" + String(describing: dateComponents.day)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createTransactionPressed(_ sender: Any) {
        let type = types[typeOfTransaction.selectedSegmentIndex]
        let comment = commentsTextField.text
        let userRef = databaseRef.child("users").child(uid!).child("stats").child(currentRound).child(currentDate)
        if let temp = Double(costTextField.text!) {
            if comment != "" && type != "" {
                /*let values : (Int, String) = (1, "")
                userRef.child(type).updateChildValues(values, withCompletionBlock: { (error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                })*/
                /*
                let values : [String : Double] = [comment! : temp]
                userRef.child(type).updateChildValues(values, withCompletionBlock: {(error, ref) in
                    if error != nil {
                        print(error!)
                        return
                    }
                })*/
 
                performSegue(withIdentifier: "transactionToHome", sender: Any?.self)
            } else {
                let alertController = UIAlertController(title: "Error", message: "Please enter a comment and type", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please enter a number for cost", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func fetchData(andOnCompletion completion:@escaping (Int)->()){
        let userRef = databaseRef.child("users").child(uid!).child("currentRound")
        var value : Int = 0
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
                value = (dict["currentRound"] as? Int!)!
            }
            completion(value)
        })
    }
    
    
    
    
    
}
