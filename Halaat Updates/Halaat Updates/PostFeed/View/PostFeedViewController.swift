//
//  PostFeedViewController.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 27/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit

class PostFeedViewController: UIViewController , Injectable {
    typealias T = PostFeedViewModel
    private var viewModel : PostFeedViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
    }

    func inject(_ viewModel: PostFeedViewModel) {
        self.viewModel = viewModel
    }

    func assertDependencies() {
        assert(viewModel != nil)
    }
    
    @IBAction func didTapOnPostButton(_ sender: UIBarButtonItem) {
        viewModel.didTapOnPostButton()
    }
    
}
