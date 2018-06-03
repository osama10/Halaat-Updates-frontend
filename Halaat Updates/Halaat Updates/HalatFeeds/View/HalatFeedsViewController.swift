//
//  HalatFeedsViewController.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 26/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit

class HalatFeedsViewController: UIViewController , Injectable , SegueHandlerType , AlertsPresentable{
    
    enum SegueIdentifier : String {
        case feed_detailview
        case post_feedview
    }
    
    @IBOutlet fileprivate weak var tableView : UITableView!
    private var viewModel : HalatFeedsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        tableView.delegate = self
        tableView.dataSource = self
        bindUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getAllFeeds()
    }
    
    func inject(_ viewModel : HalatFeedsViewModel) {
        self.viewModel = viewModel
    }
    
    func assertDependencies() {
        assert(viewModel != nil)
    }
    
    func bindUI(){
        viewModel?.showAlert = {[weak self] (title , message) in
            guard let this = self else {return}
            this.showAlert(with: title, and: message)
        }
        viewModel?.showLoader = { [weak self] in
            guard let this = self else {return}
            this.view.makeToastActivity(.center)
        }
        viewModel?.hideLoader = { [weak self] in
            guard let this = self else {return}
            this.view.hideToastActivity()
        }
        viewModel?.refreshHalaatWall = {[weak self] in
            guard let this = self else {return}
            this.tableView.reloadData()
        }
        viewModel?.performLogout = {[weak self] in
            guard let this = self else {return}
            this.dismiss(animated: true, completion: nil)
        }
        viewModel?.performSegueToFeedDetails = {[weak self] in
            guard let this = self else {return}
            this.performSegueWithIdentifier(segueIdentifier: .feed_detailview, sender: this)
        }
        viewModel?.performSegueToPostFeedView = {[weak self] in
            guard let this = self else {return}
            this.performSegueWithIdentifier(segueIdentifier: .post_feedview, sender: this)
        }
    }
    
    @IBAction func didTapOnLogouButton(_ sender: UIBarButtonItem) {
        viewModel?.didTapOnLogoutButton()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifierForSegue(segue: segue){
            
        case .feed_detailview:
            
            guard let destVc = segue.destination as? FeedDetailViewController else {return}
            destVc.inject((viewModel?.getFeedDetailViewModel())!)
            
        case .post_feedview:
           
            guard let destVc = segue.destination as? PostFeedViewController else {return}
            destVc.inject((viewModel?.getPostFeedViewModel())!)
            
        }
        
    }
}

extension HalatFeedsViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.numberOfRows())!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return tableView.dequeResuseableCell(for: indexPath) as HalatFeedsTableViewCell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let halatCell = cell as? HalatFeedsTableViewCell else {return}
        halatCell.inject((viewModel?.getHalatFeedsCellViewModel(of: indexPath.row))!)
        halatCell.viewModelDidBind()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat((viewModel?.heightForRow())!)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didSelectRow(at: indexPath.row)
    }
    
}
