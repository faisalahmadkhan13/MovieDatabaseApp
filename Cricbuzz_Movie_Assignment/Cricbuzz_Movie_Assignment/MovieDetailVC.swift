//
//  MovieDetailVC.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

class MovieDetailVC: UIViewController,XibLoadable {
    
    enum DetailSection {
        case header
    }
    
    @IBOutlet private weak var detailCollectionView:UICollectionView!
    private var datasource:UICollectionViewDiffableDataSource<DetailSection,MovieModel>! = nil
    
    var img:UIImage?
    
    var movieData:MovieModel? = nil
    var viewModel = MovieDetailViewModel()
    weak var coordinator:MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        // Do any additional setup after loading the view.
    }
    
    private func initialSetup() {
        self.registerCell()
        self.setCollectionView()
        self.configureDatasource()
        if let movieData {
            viewModel.fetchImg(str: movieData.poster) {[weak self] image in
                guard let self = self else { return }
                self.img = image
                self.applySnapshot()
            }
        }
        
       
    }
    
    private func registerCell() {
        detailCollectionView.register(UINib(nibName: "MovieDetailCell", bundle: nil), forCellWithReuseIdentifier: "MovieDetailCell")
    }
    
    private func setCollectionView() {
        detailCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber,env) -> NSCollectionLayoutSection? in
            guard self != nil else { return nil }
            var sectionLayout: NSCollectionLayoutSection
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            configuration.backgroundColor = .clear
            configuration.showsSeparators = false
            configuration.headerMode = .none
            sectionLayout = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
            sectionLayout.contentInsets = insets
            return sectionLayout
        }
        return layout
    }
    
    private func configureDatasource(){
        datasource = UICollectionViewDiffableDataSource<DetailSection,MovieModel>(collectionView: self.detailCollectionView) {[weak self] collectionView, indexPath, data -> UICollectionViewCell? in
            guard let self = self else { return nil }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieDetailCell", for: indexPath) as? MovieDetailCell else { return nil }
            cell.setData(movieData: movieData, img: img)
            return cell
        }
    }
    
    private func applySnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<DetailSection,MovieModel>()
        snapshot.appendSections([.header])
        if let movieData {
            snapshot.appendItems([movieData],toSection: .header)
        }
        datasource.apply(snapshot, animatingDifferences: true)
    }
}
    
