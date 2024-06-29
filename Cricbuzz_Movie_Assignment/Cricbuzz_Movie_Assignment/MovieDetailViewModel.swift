//
//  MovieDetailViewModel.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation
import UIKit

class MovieDetailViewModel {
    
    func fetchImg(str:String,completion:@escaping(UIImage?)->()) {
        if let url = URL(string: str) {
            ImageLoader.shared.loadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                  completion(image)
                }
            }
        }
    }
}
