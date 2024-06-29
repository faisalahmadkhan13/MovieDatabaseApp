//
//  ImageLoader.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation
import UIKit

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    private var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

