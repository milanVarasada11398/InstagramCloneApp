//
//  AddPostViewController.swift
//  Instagram
//
//  Created by Milan Varasada on 01/07/19.
//  Copyright © 2019 Milan Varasada. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import Photos
import SVProgressHUD
import Crashlytics
import Fabric

class AddPostViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let storage = Storage.storage() //storage path
    var imageName = ""
    var randomID = ""
    let db = Firestore.firestore() //db path
    var imagePicker = UIImagePickerController()
    
    //outlets for Images and description
    @IBOutlet var postDataView: UITextView!
    @IBOutlet var selectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the detailsview
        postDataView.layer.cornerRadius = 5
        postDataView.layer.borderColor = UIColor.purple.cgColor
        postDataView.layer.borderWidth = 2
        Fabric.sharedSDK().debug = true
    }
    

    @IBAction func shareThisPost(_ sender: Any) {
        if postDataView.text.isEmpty == true
        {
            //alert on empty view
              let alert = UIAlertController(title: "Alert", message: "Please Enter Your Post...", preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
              self.present(alert, animated: true, completion: nil)
        }
        else
        {
            var ref: DocumentReference? = nil
            ref = db.collection("posts").addDocument(data: [
            "postdata": "\(postDataView.text!)",
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
            randomID = (ref?.documentID)!
             UploadData()
            SVProgressHUD.show()
        postDataView.text = ""
            selectedImage.image = nil
    }
}
    
    @IBAction func AddImage(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        present(imagePicker, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
                selectedImage = editedImage
                self.selectedImage.image = selectedImage!
                picker.dismiss(animated: true, completion: nil)
        } else if let originalImage = info[.originalImage] as? UIImage {
                selectedImage = originalImage
                self.selectedImage.image = selectedImage!
         
        }
        guard let fileUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else { return }
        print(fileUrl.lastPathComponent)
        imageName = fileUrl.lastPathComponent
        picker.dismiss(animated: true, completion: nil)
    }
 
    @IBAction func AddVideos(_ sender: Any) {
       //add videos
    }
    
    
    func UploadData()
    {
        let uploadRef=Storage.storage().reference(withPath: "Images/\(randomID).jpg")
        guard let imageData = selectedImage.image?.jpegData(compressionQuality: 0.75) else {return}
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
       //upload data
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error
            {
                print("error \(error.localizedDescription)")
            }
             //You Can use Native Spinner or ProgressBar instead of ThirdParty Libraries
             SVProgressHUD.dismiss()
        }
     
    }
}
