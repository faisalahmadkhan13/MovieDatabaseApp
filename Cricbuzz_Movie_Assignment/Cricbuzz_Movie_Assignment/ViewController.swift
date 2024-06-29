//
//  ViewController.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import UIKit

enum Section : Hashable {
    case year(list:[String],isExpanded:Bool)
    case genre(list:[String],isExpanded:Bool)
    case directors(list:[String],isExpanded:Bool)
    case actors(list:[String],isExpanded:Bool)
    case allMovies(list:[MovieModel],isExpanded:Bool)
    case search(filterList:[MovieModel])
}

class ViewController: UIViewController,Storyboarded {
    
    @IBOutlet private weak var movieCollectionView:UICollectionView!
    @IBOutlet private weak var searchBar:UISearchBar!
    private var datasource:UICollectionViewDiffableDataSource<Section,AnyHashable>! = nil
    var viewModel = ViewModel()
    weak var coordinator:MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    private func initialSetup() {
        self.registerCell()
        self.setCollectionView()
        self.configureDatasource()
        viewModel.fetchData()
        DispatchQueue.main.async {
            self.applySnapshot()
        }
        searchBar.delegate = self
        searchBar.placeholder = "Search movies by title/genre/actor/director"
    }
    
    private func registerCell() {
        movieCollectionView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCell")
        movieCollectionView.register(UINib(nibName: "FilterListCell", bundle: nil), forCellWithReuseIdentifier: "FilterListCell")
        movieCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView")
    }
    
    private func setCollectionView() {
        movieCollectionView.delegate = self
        movieCollectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let insets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionNumber,env) -> NSCollectionLayoutSection? in
            guard self != nil else { return nil }
            var sectionLayout: NSCollectionLayoutSection
            var configuration = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
            configuration.backgroundColor = .clear
            configuration.showsSeparators = true
            configuration.headerMode = .supplementary
            sectionLayout = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: env)
            sectionLayout.contentInsets = insets
            return sectionLayout
        }
        return layout
    }
    
    private func configureDatasource(){
        datasource = UICollectionViewDiffableDataSource<Section,AnyHashable>(collectionView: self.movieCollectionView) {[weak self] collectionView, indexPath, data -> UICollectionViewCell? in
            guard let self = self else { return nil }
            var section:Section
            if viewModel.isSearchEnable {
                section = .search(filterList: [])
            } else {
                section = self.viewModel.lists[indexPath.section]
            }
           
            switch section {
            case .year(_,_) , .genre(_,_) , .directors(_,_) , .actors(_,_) :
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterListCell", for: indexPath) as? FilterListCell else { return nil }
                if let title = data as? String {
                    cell.setup(title: title)
                }
                return cell
            case .allMovies(_,_),.search(filterList: _):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else { return nil }
                if let movieData = data as? MovieModel {
                    cell.setup(data: movieData)
                }
                return cell
            }
        }
        
        datasource.supplementaryViewProvider = {[weak self] (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil}
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier:"HeaderView", for: indexPath) as? HeaderView else {
                fatalError("Unable to debug")
            }
            if viewModel.isSearchEnable {
                supplementaryView.setup(section: .search(filterList: []))
            } else {
                supplementaryView.setup(section: viewModel.lists[indexPath.section])
            }
            
            supplementaryView.delegate = self
            return supplementaryView
        }
    }
    
    private func applySnapshot(searchData:[MovieModel]? = nil){
        var snapshot = NSDiffableDataSourceSnapshot<Section,AnyHashable>()
        if let searchData {
            snapshot.deleteAllItems()
            snapshot.appendSections([.search(filterList: searchData)])
            snapshot.appendItems(searchData, toSection: .search(filterList: searchData))
        } else  {
            snapshot.deleteAllItems()
            viewModel.lists.forEach { section in
                snapshot.appendSections([section])
                switch section {
                case .year(let list,let isexpanded):
                    snapshot.appendItems(isexpanded ? list : [], toSection: section)
                case .genre(let list,let isexpanded):
                    snapshot.appendItems(isexpanded ? list : [], toSection: section)
                case .directors(let list,let isexpanded):
                    snapshot.appendItems(isexpanded ? list : [], toSection: section)
                case .actors(let list,let isexpanded):
                    snapshot.appendItems(isexpanded ? list : [], toSection: section)
                case .allMovies(let list,let isexpanded):
                    snapshot.appendItems(isexpanded ? list : [], toSection: section)
                case .search(filterList: _):
                    break
                }
            }
        }
      
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var section:Section
        if viewModel.isSearchEnable {
            section = .search(filterList: [])
        } else {
            section = viewModel.lists[indexPath.section]
        }
        switch section {
        case .year(let list,_):
            coordinator?.navigateToFilterCategoryListVC(list: viewModel.movieList.filter{$0.year == list[indexPath.item]})
        case .genre(let list,_):
            coordinator?.navigateToFilterCategoryListVC(list: viewModel.movieList.filter{$0.genre.contains(list[indexPath.item])})
        case .directors(let list,_):
            coordinator?.navigateToFilterCategoryListVC(list: viewModel.movieList.filter{$0.director.contains(list[indexPath.item])})
        case .actors(let list,_):
            coordinator?.navigateToFilterCategoryListVC(list: viewModel.movieList.filter{$0.actors.contains(list[indexPath.item])})
        case .allMovies(let list,_):
            coordinator?.navigateToMovieDetail(data: list[indexPath.item])
        case .search(filterList: let list):
            if let item = datasource.itemIdentifier(for: indexPath) as? MovieModel {
                coordinator?.navigateToMovieDetail(data: item)
            }
           
        }
    }
}

extension ViewController : HeaderTapDelegate {
    func tap(section: Section?) {
        if viewModel.isSearchEnable {
            return
        }
        if let section {
            if let index = viewModel.lists.firstIndex(of: section) {
                switch section {
                case .year(let list, let isExpanded):
                    viewModel.lists[index] = .year(list: list, isExpanded: !isExpanded)
                case .genre(let list, let isExpanded):
                    viewModel.lists[index] = .genre(list: list, isExpanded: !isExpanded)
                case .directors(let list, let isExpanded):
                    viewModel.lists[index] = .directors(list: list, isExpanded: !isExpanded)
                case .actors(let list, let isExpanded):
                    viewModel.lists[index] = .actors(list: list, isExpanded: !isExpanded)
                case .allMovies(let list, let isExpanded):
                    viewModel.lists[index] = .allMovies(list: list, isExpanded: !isExpanded)
                case .search(filterList: _):
                    break
                }
            }
        }
        self.applySnapshot()
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text {
            if !text.isEmpty {
                self.applySnapshot(searchData: viewModel.searchFilter(searchKey: text))
            } else {
                self.applySnapshot()
                viewModel.isSearchEnable = false
            }
        } else {
            self.applySnapshot()
            viewModel.isSearchEnable = false
        }
    }
}
