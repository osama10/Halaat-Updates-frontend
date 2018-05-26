//
//  HalatFeedsTableViewCell.swift
//  Halaat Updates
//
//  Created by inVenD on 26/05/2018.
//  Copyright © 2018 freelance. All rights reserved.
//

import UIKit
import SDWebImage

class HalatFeedsTableViewCell: UITableViewCell , ReusableView , Injectable  {
    
    typealias T = HalatFeedsCellViewModel
    
    
    @IBOutlet fileprivate weak var title : UILabel!
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
        viewModel?.setData = { [weak self] (data) in
            
            guard let this = self else {return}
            this.viewModel?.setDefaultImage = {[weak self] (imageUrl) in
                guard let this = self else {return}
                this.ivImage?.contentMode = .scaleToFill
                this.ivImage?.image = UIImage(named: imageUrl)
            }
            this.viewModel?.setImageFromUrl = {[weak self] (imageUrl) in
                guard let this = self else {return}
                this.ivImage?.contentMode = .scaleToFill
                this.ivImage?.sd_setImage(with: imageUrl, completed: nil)
            }
            
            this.title.text = data.title
            this.viewModel?.setImage(accordingTo: data.image ?? "none")
        }
    }
    
    
    private func setUI(){
        viewModel?.setUI = {[weak self] in
            guard let this = self else {return}
            Utils.createCardView(view: this.overLayView, backgroundColor: UIColor.white, borderColor: UIColor.black, borderWidth: 2.0)
        }
    }
}
