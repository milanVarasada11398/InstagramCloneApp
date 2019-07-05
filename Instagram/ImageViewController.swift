//
//  ImageViewController.swift
//  Instagram
//
//  Created by Milan Varasada on 05/07/19.
//  Copyright © 2019 Milan Varasada. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet var lblText: UILabel!
    @IBOutlet var selectedImage: UIImageView!
    var img:UIImage?
    var pinchGesture = UIPinchGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
     
        selectedImage.image = img
        selectedImage.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handletap))
        selectedImage.addGestureRecognizer(tap)
        let longtap = UILongPressGestureRecognizer(target: self, action: #selector(self.longtap))
        selectedImage.addGestureRecognizer(longtap)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        selectedImage.addGestureRecognizer(pan)
        self.pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(pinch:)))
        self.selectedImage.addGestureRecognizer(self.pinchGesture)
        let rotate = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotate(recognizer:)))
        selectedImage.addGestureRecognizer(rotate)
    }
    
    @objc func handletap()
    {
        print("tap")
        lblText.text = "Clicked Image"
    }
    @objc func longtap()
    {
      
        lblText.text = "long tap Image"
    }
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    @objc func pinchRecognized(pinch: UIPinchGestureRecognizer) {
        pinch.view?.transform = (pinch.view?.transform.scaledBy(x: pinch.scale, y: pinch.scale))!
        pinch.scale = 1
        }
    
    
    

    @IBAction func backButton(_ sender: Any) {
         navigationController?.popViewController(animated: true)
    }
    
    @objc func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    

}
