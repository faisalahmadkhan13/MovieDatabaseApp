//
//  MovieListCell.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    
    @IBOutlet private weak var posterImageView:UIImageView!
    @IBOutlet private weak var titleLabel:UILabel!
    @IBOutlet private weak var languageLabel:UILabel!
    @IBOutlet private weak var yearLabel:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(systemName: "photo")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
    }
    
    func setup(data:MovieModel) {
        self.titleLabel.text = data.title
        self.languageLabel.text = "Languages: \(data.language)"
        self.yearLabel.text = "Year: \(data.year)"
        if let url = URL(string: data.poster) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if image == nil {
                        
                    } else {
                        self.posterImageView.image = image
                    }
                }
            }
        }
    }

}
