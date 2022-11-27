//
//  itemsCell.swift
//  Brokol
//
//  Created by Ammaar Khan on 26/11/2022.
//

import UIKit

class itemsCell: UITableViewCell {

    @IBOutlet weak var item: UILabel!
    
    @IBOutlet weak var expiry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
