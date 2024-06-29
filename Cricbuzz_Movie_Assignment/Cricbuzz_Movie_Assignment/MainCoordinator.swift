//
//  MainCoordinator.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation

import Foundation
import UIKit

class MainCoordinator : Coordinator {
    var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToFilterCategoryListVC(list:[MovieModel]) {
        let vc = FilterCategoryListVC.instantiate()
        vc.coordinator = self
        vc.list = list
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func navigateToMovieDetail(data:MovieModel) {
        let vc = MovieDetailVC.instantiate()
        vc.coordinator = self
        vc.movieData = data
        self.navigationController.pushViewController(vc, animated: true)
    }
}
