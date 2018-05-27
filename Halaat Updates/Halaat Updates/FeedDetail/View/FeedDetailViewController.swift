//
//  FeedDetailViewController.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController , Injectable {
    typealias T = FeedDetailViewModel
    
    @IBOutlet fileprivate weak var lbAuthor : UILabel!
    @IBOutlet fileprivate weak var lbDatePosted : UILabel!
    @IBOutlet fileprivate weak var tvDetails : UITextView!
    @IBOutlet fileprivate weak var ivImage : UIImageView!
    
    fileprivate var viewModel : FeedDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setUI()
    }

    func setUI(){
        title = viewModel.setTitle()
        lbAuthor.text = viewModel.setAuthor()
        lbDatePosted.text = viewModel.setDatePosted()
        tvDetails.text = viewModel.setDetails()
    }
    func inject(_ viewModel: FeedDetailViewModel) {
        self.viewModel = viewModel
    }

    func assertDependencies() {
        assert(viewModel != nil)
    }
}
