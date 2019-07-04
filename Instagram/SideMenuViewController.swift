//
//  SideMenuViewController.swift
//  Instagram
//
//  Created by Milan Varasada on 03/07/19.
//  Copyright © 2019 Milan Varasada. All rights reserved.
//

import UIKit
import SideMenu
import MessageUI
import FirebaseAuth
import GoogleSignIn
import Firebase
import Fabric
import Crashlytics

class SideMenuViewController: UIViewController,MFMailComposeViewControllerDelegate {

    //varient variables
    var name:String=""
    var url:URL?
    
    //outlets
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var ratingControl: RatingControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name=(Auth.auth().currentUser?.displayName)!
        url=Auth.auth().currentUser?.photoURL
           Fabric.sharedSDK().debug = true
        //propic initializations
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        nameLabel.text = name
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let image = UIImage(data: imageData)
            profileImage.image = image
        }
      navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func logoutUser(_ sender: Any) {
        
        //Mark:-change login key
        UserDefaults.standard.set(false, forKey: "login")
        GIDSignIn.sharedInstance().signOut()
        self.dismiss(animated: false, completion: nil)
        navigationController?.popToRootViewController(animated: false)
      
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "login") as? ViewController
        vc!.modalTransitionStyle = .flipHorizontal
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = vc
    }
    
    @IBAction func shareApp(_ sender: Any) {
        let actionSheetController = UIAlertController(title: "Please select Your Option", message: "", preferredStyle: .actionSheet)
        
        //otherbutton
        let otherButton = UIAlertAction(title: "Share via Others", style: .default) { action -> Void in
            print("Others")
            let shareText = "Hello You are In Instagram App"
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: [])
            self.present(vc, animated: true, completion: nil)
        }
        actionSheetController.addAction(otherButton)
        
        //cancelbutton
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("cancel")
        }
        actionSheetController.addAction(cancelButton)
        
        //emailbutton
        let emailButton = UIAlertAction(title: "Share via Email", style: .default) { action -> Void in
            print("Email")
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients(["test@test.test"])
                mail.setSubject("Bla")
                mail.setMessageBody("<b>Blabla</b>", isHTML: true)
                self.present(mail, animated: true, completion: nil)
            } else {
                print("Cannot send mail")
            }
        }
        actionSheetController.addAction(emailButton)
        
        //messagebutton
        let MessageButton = UIAlertAction(title: "Share via Messages", style: .default) { action -> Void in
            print("Message")
          UIApplication.shared.open(URL(string: "sms:")!, options: [:], completionHandler: nil)
        }
        actionSheetController.addAction(MessageButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    //home
    @IBAction func gotoHome(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //mail func
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing: error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
   
    
}
