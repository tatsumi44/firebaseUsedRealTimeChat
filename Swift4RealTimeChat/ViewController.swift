//
//  ViewController.swift
//  Swift4RealTimeChat
//
//  Created by tatsumi kentaro on 2018/02/18.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDataSource {
   
    
    var db: DatabaseReference!
    
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var commentTextFeild: UITextField!
    var contentsArray = [String: String]()
    var getArray = [String]()
    var getMainArray = [[String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        db = Database.database().reference()
        db.ref.child("chat").child("message").observe(.value) { (snap) in
            for item in snap.children {
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                self.getArray = [dic["name"]! as! String, dic["contents"]! as! String]
                self.getMainArray.append(self.getArray)
                
//                self.textView.text = "\(dic["contents"]!): \(dic["name"]!)"
            }
            print(self.getMainArray)
            self.table.reloadData()

        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = "\(getMainArray[indexPath.row][0]):\(getMainArray[indexPath.row][1])"
        return cell!
    }
 
    @IBAction func sendButton(_ sender: Any) {
        getMainArray = [[String]]()
        contentsArray = ["name": nameTextField.text!,"contents": commentTextFeild.text!]
        db.ref.child("chat").child("message").childByAutoId().setValue(contentsArray)
        nameTextField.text = ""
        commentTextFeild.text = ""
        
    }
    
    
}

