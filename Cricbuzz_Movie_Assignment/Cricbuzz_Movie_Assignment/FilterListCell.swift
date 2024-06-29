//
//  FilterListCell.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

class FilterListCell: UICollectionViewCell {
    
    @IBOutlet private weak var titleLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(title:String) {
        self.titleLabel.text = title
    }

}
