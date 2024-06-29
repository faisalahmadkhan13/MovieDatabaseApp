//
//  HeaderView.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

protocol HeaderTapDelegate : AnyObject {
    func tap(section:Section?)
}

class HeaderView: UICollectionReusableView {
    
    @IBOutlet private weak var titleLabel:UILabel!
    @IBOutlet private weak var indicatorBtn:UIButton!
    @IBOutlet private weak var btnTap:UIButton!
    @IBOutlet private weak var separatorView:UIView!
    
    private lazy var section : Section? = nil
    weak var delegate:HeaderTapDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.indicatorBtn.tintColor = .lightGray
        self.separatorView.backgroundColor = .lightGray
        self.bringSubviewToFront(btnTap)
    }
    
    func setup(section:Section) {
        self.section = section
        separatorView.isHidden = false
        switch section {
        case .year(_,_):
            self.titleLabel.text = "Year"
        case .genre(_,_):
            self.titleLabel.text = "Genre"
        case .directors(_,_):
            self.titleLabel.text = "Director"
        case .actors(_,_):
            self.titleLabel.text = "Actors"
        case .allMovies(_,_):
            self.titleLabel.text = "All Movies"
        case .search(filterList: _):
            self.titleLabel.text = "Search Result"
        }
    }
    
    @IBAction func headerTap(_ sender : UIButton) {
        if let delegate , let section  {
            delegate.tap(section: section)
        }
    }
    
}
