//
//  BusinessCell.swift
//  Yelp
//
//  Created by Mogulla, Naveen on 4/5/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var business: Business! {
        didSet{
            titleLabel.text = business.name
            ratingImageView.setImageWith(business.ratingImageURL!)
            posterImageView.setImageWith(business.imageURL!)
            addressLabel.text = business.address
            categoryLabel.text = business.categories
            distanceLabel.text = business.distance
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterImageView.layer.cornerRadius = 4
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.preferredMaxLayoutWidth = titleLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
