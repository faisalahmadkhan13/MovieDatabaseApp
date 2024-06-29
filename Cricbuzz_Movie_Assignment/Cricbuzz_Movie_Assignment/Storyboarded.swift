//
//  Storyboarded.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate()->Self
}

extension Storyboarded where Self:UIViewController {
    static func instantiate()->Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}

protocol XibLoadable where Self: UIViewController {
    static func instantiate() -> Self
}

extension XibLoadable where Self: UIViewController {
    static func instantiate() -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        return Self(nibName: className, bundle: Bundle.main)
    }
}
