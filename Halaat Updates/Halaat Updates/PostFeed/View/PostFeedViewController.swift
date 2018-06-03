//
//  PostFeedViewController.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit

class PostFeedViewController: UIViewController , Injectable , AlertsPresentable {
   
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptonTextView: UITextView!
    
    private var imagePickerUtils : ImagePickerUtils!
    private var viewModel : PostFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setUI()
        bindUI()
        addTapGesture(on: postImageView)
        imagePickerUtils = ImagePickerUtils(delegate: self , pickerViewController: self)
    }

    func inject(_ viewModel: PostFeedViewModel) {
        self.viewModel = viewModel
    }

    func assertDependencies() {
        assert(viewModel != nil)
    }
    
    private func bindUI(){
        viewModel.makeTitleEditable = {[weak self] in
            guard let this = self else {return}
            this.titleTextField.isUserInteractionEnabled = true
            this.titleTextField.becomeFirstResponder()
        }
    
        viewModel.makeDescriptionEditable = {[weak self] in
            guard let this = self else {return}
            this.descriptonTextView.isUserInteractionEnabled = true
            this.descriptonTextView.becomeFirstResponder()
        }
        
        viewModel.openImagePickerController = {[weak self] in
            guard let this = self else {return}
            this.imagePickerUtils.photoFromGallery()
        }
        
        viewModel.showAlert = { [weak self] (title , message) in
            guard let this = self else {return}
            this.showAlert(with: title, and: message)
        }
        
        viewModel.dismissViewController = {[weak self] in
            guard let this = self else {return}
            this.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setUI(){
        titleTextField.isUserInteractionEnabled = false
        descriptonTextView.isUserInteractionEnabled = false
    }
   
    private func addTapGesture(on imageView : UIImageView){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPicture))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func didTapOnPostButton(_ sender: UIBarButtonItem) {
        viewModel.didTapOnPostButton()
    }
    
    @IBAction func didTapOnEditTitleButton(_ sender: UIButton) {
        viewModel.didTapOnEditTitleButton()
    }
    
    @IBAction func didTapOnEditDescriptionButton(_ sender: UIButton) {
        viewModel.didTapOnEditDescriptionButton()
    }
    
    @objc private func selectPicture(){
        viewModel.didTapOnSelectPicture()
    }
}

extension PostFeedViewController : ImagePickerUtilsDelegate {
    func didFinishPickingImage(selectedImage: UIImage) {
        self.postImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func didTapOnCancel() {
        viewModel.didTapOnCancel()
    }
    
    func cameraNotAvailable() {
        viewModel.cameraNotAvailable()
    }
}
