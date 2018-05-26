//
//  HalatFeedsViewController.swift
//  Halaat Updates
//
//  Created by inVenD on 26/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import UIKit

class HalatFeedsViewController: UIViewController , Injectable {
    typealias T = HalatFeedsViewModel
    private var viewModel : HalatFeedsViewModel?
    @IBOutlet fileprivate weak var tableView : UITableView!
    
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
    
    func inject(_ viewModel : T) {
        self.viewModel = viewModel
    }
    
    func assertDependencies() {
        assert(viewModel != nil)
    }

    func bindUI(){
        viewModel?.showAlert = {[weak self] (title , message) in
            guard let this = self else {return}
            this.showAlertControllerWithOkTitle(title: title, message: message)
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
    
    
}
