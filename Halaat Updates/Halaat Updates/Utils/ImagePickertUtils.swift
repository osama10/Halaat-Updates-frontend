//
//  ImagePickertUtils.swift
//  Halaat Updates
//
//  Created by inVenD on 03/06/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import Foundation
import UIKit

protocol ImagePickerUtilsDelegate : class {
    func didFinishPickingImage(selectedImage : UIImage)
    func didTapOnCancel()
    func cameraNotAvailable()
}

class ImagePickerUtils : NSObject {
    
    private let imagePicker =  UIImagePickerController()
    private weak var pickerViewController : UIViewController!
    private weak var delegate : ImagePickerUtilsDelegate!
    
    init(delegate : ImagePickerUtilsDelegate , pickerViewController : UIViewController) {
        super.init()
     
        imagePicker.delegate = self
        self.delegate = delegate
        self.pickerViewController = pickerViewController
    }
    
    func photoFromGallery() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerViewController.present(imagePicker, animated: true, completion: nil)
    }
    
    func photoFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            pickerViewController.present(imagePicker,animated: true,completion: nil)
            
        } else {
            delegate.cameraNotAvailable()
        }
    }

    
}

extension ImagePickerUtils :  UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
   internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate.didFinishPickingImage(selectedImage: selectedImage)
    }
    
   internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate.didTapOnCancel()
    }
}
