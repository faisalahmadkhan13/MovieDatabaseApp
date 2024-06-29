//
//  FilterCategoryListVC.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

class FilterCategoryListVC: UIViewController,XibLoadable {
    
    enum FilterSection {
        case header
    }
    
    @IBOutlet private weak var filterCollectionView:UICollectionView!
    private var datasource:UICollectionViewDiffableDataSource<FilterSection,MovieModel>! = nil
    var list:[MovieModel] = []
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
        self.applySnapshot()
    }
    
    private func registerCell() {
        filterCollectionView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCell")
    }
    
    private func setCollectionView() {
        filterCollectionView.delegate = self
        filterCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber,env) -> NSCollectionLayoutSection? in
            guard self != nil else { return nil }
            var sectionLayout: NSCollectionLayoutSection
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
            configuration.backgroundColor = .clear
            configuration.showsSeparators = true
            configuration.headerMode = .none
            sectionLayout = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
            sectionLayout.contentInsets = insets
            return sectionLayout
        }
        return layout
    }
    
    private func configureDatasource(){
        datasource = UICollectionViewDiffableDataSource<FilterSection,MovieModel>(collectionView: self.filterCollectionView) {[weak self] collectionView, indexPath, data -> UICollectionViewCell? in
            guard self != nil else { return nil }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else { return nil }
            cell.setup(data: data)
            return cell
        }
    }
    
    private func applySnapshot(){
        var snapshot = NSDiffableDataSourceSnapshot<FilterSection,MovieModel>()
        snapshot.appendSections([.header])
        snapshot.appendItems(list,toSection: .header)
        datasource.apply(snapshot, animatingDifferences: true)
    }
}

extension FilterCategoryListVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.navigateToMovieDetail(data: list[indexPath.item])
    }
}
