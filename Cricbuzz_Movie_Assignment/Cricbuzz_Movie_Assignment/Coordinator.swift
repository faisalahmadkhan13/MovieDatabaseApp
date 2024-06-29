//
//  Coordinator.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController:UINavigationController {get set}
    func start()
}
