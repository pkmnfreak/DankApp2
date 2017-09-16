//
//  searchViewController.swift
//  DankApp
//
//  Created by Evan Chang on 16/09/17.
//  Copyright © 2017 Evan Chang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class searchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let databaseRef = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    var competitors = [String]()
    var competitorIDs = [String]()
    
    @IBOutlet weak var toHomeButton: UIButton!
    
    @IBOutlet weak var numberOfDaysTextField: UITextField!
    
    @IBOutlet weak var searchBarTextField: UITextField!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createGameButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchBarTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            let username = searchBarTextField.text!
            databaseRef.child("users").queryOrdered(byChild: "username").queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String : AnyObject] {
                    let name = (Array(dict.values)[0] as! [String : AnyObject])["username"]!
                    let inComp = (Array(dict.values)[0] as! [String : AnyObject])["inComp"]! as! Bool
                    let id = Array(dict.keys)[0] as! String
                    if (!inComp && !self.competitors.contains(name as! String)) {
                        self.competitors.append(name as! String)
                        self.competitorIDs.append(id)
                        self.searchTableView.reloadData()
                    } else {
                        let alertController = UIAlertController(title: "Error", message: (name as! String) + " is already in a competition", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                }) { (err) in
                    print(err)
                }
        }
    }
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "searchToHome", sender: Any?.self)
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        competitors.remove(at: indexPath.row)
        competitorIDs.remove(at: indexPath.row)
        searchTableView.reloadData()
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchTableViewCell
        cell.usernameLabel.text = competitors[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitors.count
    }
    
}
