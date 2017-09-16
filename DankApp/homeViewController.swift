//
//  homeViewController.swift
//  DankApp
//
//  Created by Evan Chang on 16/09/17.
//  Copyright © 2017 Evan Chang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class homeViewController: UIViewController {
    
    let databaseRef = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var toSearchButton: UIButton!
    
    @IBOutlet weak var medalTableView: UITableView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var streakTableView: UITableView!
    
    @IBOutlet weak var numberOfDaysTextField: UITextField!
    
    @IBOutlet weak var competitorTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toSearchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToSearch", sender: Any?.self)
    }
    
    @IBAction func addTransactionPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToTransaction", sender: Any?.self)
    }
    
    func fetchData(andOnCompletion completion:@escaping (Int)->()){
        let userRef = databaseRef.child("users").child(uid!).child("currentRound")
        var value : Int = 0
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String : AnyObject] {
                value = (dict["currentRound"] as? Int)!
            }
            completion(value)
        })
    }
    
}
