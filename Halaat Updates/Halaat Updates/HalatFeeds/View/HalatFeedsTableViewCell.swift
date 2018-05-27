//
//  HalatFeedsTableViewCell.swift
//  Halaat Updates
//
//  Created by Osama Bin Bashir on 26/05/2018.
//  Copyright © 2018 Osama Bin Bashir. All rights reserved.
//

import UIKit
import SDWebImage

class HalatFeedsTableViewCell: UITableViewCell , ReusableView , Injectable  {
    
    typealias T = HalatFeedsCellViewModel
    
    @IBOutlet fileprivate weak var title : UILabel!
    @IBOutlet fileprivate weak var author : UILabel!
    @IBOutlet fileprivate weak var datePosted : UILabel!
    @IBOutlet fileprivate weak var ivImage : UIImageView!
    @IBOutlet fileprivate weak var overLayView : UIView!
    
    private var viewModel : HalatFeedsCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func inject(_ viewModel: HalatFeedsCellViewModel) {
        self.viewModel = viewModel
        
    }
    func assertDependencies() {
        assert(viewModel != nil)
    }
    
    func viewModelDidBind(){
        assertDependencies()
        bindUI()
        setUI()
        viewModel?.viewModelDidBinUI()
    }
    private  func bindUI(){
        viewModel?.setData = { [weak self] () in
            guard let this = self else {return}
            this.title.text = this.viewModel?.setTitleOfFeed()
            this.author.text = this.viewModel?.setAuthorOfFeed()
            this.datePosted.text = this.viewModel?.setDateOnWhichFeedPosted()
            this.viewModel?.setImage()
        }
        viewModel?.setDefaultImage = {[weak self] (imageUrl) in
            guard let this = self else {return}
            this.ivImage?.contentMode = .scaleToFill
            this.ivImage?.image = UIImage(named: imageUrl)
        }
        viewModel?.setImageFromUrl = {[weak self] (imageUrl) in
            guard let this = self else {return}
            this.ivImage?.contentMode = .scaleToFill
            this.ivImage?.sd_setImage(with: imageUrl, completed: nil)
        }
    }
    
    
    private func setUI(){
        viewModel?.setUI = {[weak self] in
            guard let this = self else {return}
            Utils.createCardView(view: this.overLayView, backgroundColor: UIColor.white, borderColor: UIColor.black, borderWidth: 2.0)
        }
    }
}
