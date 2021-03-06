//
//  ViewController.swift
//  Swift4RealTimeChat
//
//  Created by tatsumi kentaro on 2018/02/18.
//  Copyright © 2018年 tatsumi kentaro. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController,UITableViewDataSource,UITextFieldDelegate {
   //UITableViewDataSource == tableViewを使うのにいる
   //UITextFieldDelegate == リターンキーを押した時の処理を行うのに使う
    
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
        nameTextField.delegate = self
        commentTextFeild.delegate = self
        //textFieldの枠、これはなくてもいい
        nameTextField.layer.borderColor = UIColor.black.cgColor
        commentTextFeild.layer.borderColor = UIColor.black.cgColor
        nameTextField.layer.borderWidth = 1.0
        commentTextFeild.layer.borderWidth = 1.0
        //使用していないセルの線を消す
        table.tableFooterView = UIView(frame: .zero)
        //tableViewの幅を指定
        table.rowHeight = 60.0
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //画面が表示されるたびに呼び出し
    override func viewWillAppear(_ animated: Bool) {
        //db接続、データの読子に
        db = Database.database().reference()
        //指定したディレクトリに変更が加わった時に呼ばれる
        db.ref.child("chat").child("message").observe(.value) { (snap) in
            self.getMainArray = [[String]]()
            for item in snap.children {
                //ここは非常にハマるfirebaseはjson形式なので変換が必要
                let child = item as! DataSnapshot
                let dic = child.value as! NSDictionary
                self.getArray = [dic["name"]! as! String, dic["contents"]! as! String]
                self.getMainArray.append(self.getArray)
            }
            print(self.getMainArray)
            //リロード
            self.table.reloadData()

        }
        
    }
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getMainArray.count
    }
    //セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let cellImageview = cell?.contentView.viewWithTag(1) as! UIImageView
        cellImageview.image = UIImage(named:"hukidashi.png")
        cell?.textLabel?.text = "  \(getMainArray[indexPath.row][0]):\(getMainArray[indexPath.row][1])"
        return cell!
    }
    //保存ボタンを押した時の処理
    @IBAction func sendButton(_ sender: Any) {
        
        contentsArray = ["name": nameTextField.text!,"contents": commentTextFeild.text!]
        //db接続、書き込み
        db.ref.child("chat").child("message").childByAutoId().setValue(contentsArray)
        //textField初期化
        nameTextField.text = ""
        commentTextFeild.text = ""
        
    }
    //リターンを押したら入力画面を閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

