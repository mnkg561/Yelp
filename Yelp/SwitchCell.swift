//
//  SwitchCell.swift
//  Yelp
//
//  Created by Mogulla, Naveen on 4/6/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
     @objc optional func switchCell (switchCell: SwitchCell, didChangeValue: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: #selector(SwitchCell.onSwitchValueChanged), for: UIControlEvents.valueChanged)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func onSwitchValueChanged(){
        
        delegate?.switchCell?(switchCell: self, didChangeValue: onSwitch.isOn)
        
    }
}
