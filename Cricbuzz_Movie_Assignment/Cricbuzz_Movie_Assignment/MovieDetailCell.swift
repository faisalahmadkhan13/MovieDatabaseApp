//
//  MovieDetailCell.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

class MovieDetailCell: UICollectionViewCell {
    
    @IBOutlet private weak var poster:UIImageView!
    @IBOutlet private weak var titleLbl:UILabel!
    @IBOutlet private weak var plot:UILabel!
    @IBOutlet private weak var director:UILabel!
    @IBOutlet private weak var writer:UILabel!
    @IBOutlet private weak var actor:UILabel!
    @IBOutlet private weak var releaseDate:UILabel!
    @IBOutlet private weak var genre:UILabel!
    @IBOutlet private weak var menuBtn:UIButton!
    @IBOutlet private weak var ratingValueLabel:UILabel!
    
    var movieData:MovieModel? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(movieData:MovieModel?,img:UIImage?) {
        guard let movieData else { return }
        self.movieData = movieData
        self.titleLbl.text = "Title : \(movieData.title)"
        self.plot.text = "Plot : \(movieData.plot)"
        self.director.text = "Director : \(movieData.director)"
        self.writer.text = "Writer : \(movieData.writer)"
        self.actor.text = "Actors : \(movieData.actors)"
        self.releaseDate.text = "Release Date : \(movieData.released)"
        self.genre.text = "Genre : \(movieData.genre)"
        if let img {
            self.poster.image = img
        } else {
            self.poster.image = UIImage(systemName: "photo")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        }
        self.ratingValueLabel.text = movieData.ratings.first?.value
        let actionClosure = { (action: UIAction) in
            self.ratingValueLabel.text = action.discoverabilityTitle
        }
        var menuChildren : [UIMenuElement] = []
        for element in movieData.ratings {
            menuChildren.append(UIAction(title: element.source,image: UIImage(named: element.source)?.withRenderingMode(.alwaysOriginal),discoverabilityTitle: element.value, handler: actionClosure))
        }
        menuBtn.menu = UIMenu(options: .displayInline, children: menuChildren)
        menuBtn.showsMenuAsPrimaryAction = true
        menuBtn.changesSelectionAsPrimaryAction = true
        self.menuBtn.tintColor = .lightGray
    }
    
}
