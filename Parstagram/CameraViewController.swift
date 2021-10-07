//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Chandana Pemmasani on 10/6/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var textToPost: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCameraBtn(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        photoView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPost(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        
        post["caption"] = textToPost.text!
        post["author"] = PFUser.current()!
        
        let imageData = photoView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] =  file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
            else {
                print("error")
            }
        }
    }
    
}
