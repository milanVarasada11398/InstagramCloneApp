//
//  ViewController.swift
//  Instagram
//
//  Created by Milan Varasada on 01/07/19.
//  Copyright © 2019 Milan Varasada. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase
import Fabric
import Crashlytics

class ViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate {
  //outlets
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var signInWithEmail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
      
        //background of login
        let view = UIView(frame: self.view.frame)
        let gradient = CAGradientLayer()
         gradient.frame = view.frame
        let gradientDark = UIColor(red: 132/255.0, green:112/255.0, blue: 255/255.0, alpha: 0.8)
        let gradientLight = UIColor(red: 128/255.0, green:105/255.0, blue: 128/255.0, alpha: 0.8)
        let gradientLight1 = UIColor(red: 255/255.0, green:0/255.0, blue: 255/255.0, alpha: 0.8)
        
        gradient.colors = [gradientDark.cgColor,gradientLight.cgColor,gradientLight1.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
        backgroundImage.addSubview(view)
        backgroundImage.bringSubviewToFront(view)
        
        //border to button
        signInWithEmail.backgroundColor = .clear
        signInWithEmail.layer.cornerRadius = 5
        signInWithEmail.layer.borderWidth = 2
        signInWithEmail.setTitleColor(.white, for: .normal)
        signInWithEmail.layer.borderColor = UIColor.white.cgColor
        
        Fabric.sharedSDK().debug = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "login") == true
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                    navigationController?.pushViewController(nextViewController, animated: false)
                }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil
        {
            print("Google error for signin")
            return
        }
        else
        {
            guard let authentication = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    return
                }
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                   nextViewController.modalTransitionStyle = .flipHorizontal
                self.present(nextViewController, animated:true, completion:nil)
            }
        }
    }
    
    @IBAction func signInToEmail(_ sender: Any) {
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        //set for session
         UserDefaults.standard.set(true, forKey: "login")
    }
}

