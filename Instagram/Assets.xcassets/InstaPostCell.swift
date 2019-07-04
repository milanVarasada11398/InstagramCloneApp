//
//  InstaPostCell.swift
//  Instagram
//
//  Created by Milan Varasada on 01/07/19.
//  Copyright © 2019 Milan Varasada. All rights reserved.
//

import UIKit
import Firebase

//update data
protocol passdata {
    func pass(poststring : String,index:Int)
}

//delete data
protocol deletedata {
    func deletePost(index:Int)
}

class InstaPostCell: UITableViewCell {
    
    //varient variables for update and delete
    var index = 0
    let db = Firestore.firestore()
    var docid = ""
    var delegate:passdata?
    var updatestr = ""
    var delegateDelete:deletedata?
    
    //outlets
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var txtView: UITextView!
    @IBOutlet var imageStory: UIImageView!
    @IBOutlet var profileImage: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //init for label and propic
        cityLabel.text = "Rajkot,Gujrat"
        nameLabel.text = "Milan Varasada"
        
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.red.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func likePost(_ sender: Any) {
         likeButton.isSelected = !likeButton.isSelected
        if((sender as AnyObject).isSelected == true)
        {
            (sender as AnyObject).setImage(UIImage(named: "like"), for: .normal)
        }
        else
        {
             (sender as AnyObject).setImage(UIImage(named: "unlike"), for: .normal)
        }
    }

    @IBAction func updatePost(_ sender: Any) {
        updatestr = txtView.text!
        print(updatestr)
        print(index)
        delegate!.pass(poststring: updatestr,index: index)
    }

    @IBAction func deletePost(_ sender: Any) {
        print(index)
        delegateDelete?.deletePost(index: index)
    }
}
