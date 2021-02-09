//
//  TableViewCell.swift
//  My Weather App
//
//  Created by Manna Pannu on 2/3/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    //mLocName
    //mCountry
    //mView
    //mTemp
    //mPinCode
    @IBOutlet weak var mTemp: UILabel!
    @IBOutlet weak var mPinCode: UILabel!
    
    @IBOutlet weak var mView: UIView!
    @IBOutlet weak var mLocName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
