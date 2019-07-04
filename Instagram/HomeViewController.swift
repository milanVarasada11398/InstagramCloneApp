//
//  HomeViewController.swift
//  Instagram
//
//  Created by Milan Varasada on 01/07/19.
//  Copyright © 2019 Milan Varasada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import Fabric
import Crashlytics

class HomeViewController: UIViewController,passdata,deletedata{

    //varient variables
    var posts : [Post] = []
    var imageArray : [UIImage] = []
    var imageID : [String] = []
    var db = Firestore.firestore()
    var post:[String] = []
    var postArray = [String: Any]() //story for collection
    var updatestring = ""
    
    //outlets
    @IBOutlet var tableview: UITableView!
    @IBOutlet var story1: UIButton!
    @IBOutlet var story2: UIButton!
    @IBOutlet var story3: UIButton!
    @IBOutlet var story4: UIButton!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change icon color
        let imagename = UIImage(named: "logoImage")
        let tintedImage = imagename?.withRenderingMode(.alwaysTemplate)
        iconImage.image = tintedImage
        iconImage.tintColor = .black
        
           Fabric.sharedSDK().debug = true
        
        //static code  -
        //Mark :- Change code while use collection view delete this code[only for user interface now]
        story1.backgroundColor = .clear
        story1.layer.cornerRadius = story1.frame.height / 2
        story1.layer.borderWidth = 1
        story1.layer.borderColor = UIColor.red.cgColor
        
        story2.backgroundColor = .clear
        story2.layer.cornerRadius = story1.frame.height / 2
        story2.layer.borderWidth = 1
        story2.layer.borderColor = UIColor.red.cgColor
        
        story3.backgroundColor = .clear
        story3.layer.cornerRadius = story1.frame.height / 2
        story3.layer.borderWidth = 1
        story3.layer.borderColor = UIColor.red.cgColor
    
        story4.backgroundColor = .clear
        story4.layer.cornerRadius = story1.frame.height / 2
        story4.layer.borderWidth = 1
        story4.layer.borderColor = UIColor.red.cgColor
        
      self.tableview.reloadData()
    }
    
    //delegates
    func pass(poststring: String,index : Int) {
        print(index)
        updatestring = poststring
        print(updatestring)
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("post:")
                print(querySnapshot?.documents[index].data()["postdata"] as! String)
                let docid = querySnapshot?.documents[index].documentID
                print(docid!)
                self.db.collection("posts").document("\(docid!)").updateData([
                    "postdata" : "\(self.updatestring)"
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                self.posts = []
                self.readData()
            }
        }
    }
    
    //delee data
    func deletePost(index: Int) {
        db = Firestore.firestore()
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("post:")
                print(querySnapshot?.documents[index].data()["postdata"] as! String)
                
                let docid = querySnapshot?.documents[index].documentID
                print("inside delete:::::\(docid!)")
                self.db.collection("posts").document("\(docid!)").delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                self.posts = []
           self.readData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.green)           //Ring Color
        SVProgressHUD.setBackgroundColor(UIColor.gray)        //HUD Color
         self.posts = []
        self.readData()
    }
}

//Mark :- Tableview Extentions

extension HomeViewController : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InstaPostCell
        cell.delegate = self
        cell.index = indexPath.row
        cell.delegateDelete = self
        let inx = posts[indexPath.row]
        cell.txtView.text = inx.post
        cell.imageStory.image = inx.image
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightOfRow = self.calculateHeight(inString: posts[indexPath.row].post)
        return (heightOfRow + 300)
    }
    
    //func for calculate dynemic height
    func calculateHeight(inString:String) -> CGFloat
    {
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15.0)]
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 370, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        let requredSize:CGRect = rect
        return requredSize.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: false)
    }
    func readData() {	
        db = Firestore.firestore()
        posts = []
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let new = Post()
                    new.post = "\(document.data()["postdata"] as! String)"
                    new.imagename = "\(document.documentID)"
                    let storageRef = Storage.storage().reference(withPath: "Images/\(document.documentID).jpg")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { data, error in
                        if let error = error {
                            print("error downloading image:\(error)")
                        } else {
                            // Data for "images/island.jpg" is returned
                            new.image = UIImage(data: data!)
                            self.posts.append(new)
                            
                            self.tableview.reloadData()
                            
                        }
                    }
                }
            }
        }
    }
    
}
