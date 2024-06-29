//
//  ViewModel.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation

class ViewModel {
    
    var lists : [Section] = []
    var movieList : [MovieModel] = []
    var isSearchEnable:Bool = false
    func fetchData() {
        self.loadJson()
    }
    
    private func loadJson() {
        if let url = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                self.movieList = try JSONDecoder().decode([MovieModel].self, from: data)
                lists.append(.year(list:  Array(Set(movieList.compactMap{$0.year})).sorted(), isExpanded: false))
                self.setGenre()
                lists.append(.directors(list: Array(Set(movieList.compactMap{$0.director})).sorted(), isExpanded: false))
                self.setActor()
                lists.append(.allMovies(list: movieList, isExpanded: true))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func setGenre() {
        var genreList : [String] = []
        let list = Array(Set(self.movieList.compactMap{$0.genre}))
        list.forEach { string in
            let subList = string.components(separatedBy: ",")
            subList.forEach { str in
                genreList.append(str.replacingOccurrences(of: " ", with: ""))
            }
        }
        lists.append(.genre(list: Array(Set(genreList)).sorted(), isExpanded: false))
    }
    
    private func setActor() {
        var actorList : [String] = []
        let list = Array(Set(self.movieList.compactMap{$0.actors}))
        list.forEach { string in
            let subList = string.components(separatedBy: ", ")
            subList.forEach { str in
                actorList.append(str)
            }
        }
        lists.append(.actors(list: Array(Set(actorList)).sorted(), isExpanded: false))
    }
    
    func searchFilter(searchKey:String)->[MovieModel] {
        self.isSearchEnable = true
        return self.movieList.filter{$0.title.contains(searchKey) || $0.genre.contains(searchKey) || $0.actors.contains(searchKey) || $0.director.contains(searchKey)}
    }
}
