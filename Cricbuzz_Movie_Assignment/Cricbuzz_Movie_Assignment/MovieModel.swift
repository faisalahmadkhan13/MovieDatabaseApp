//
//  MovieModel.swift
//  Cricbuzz_Movie_Assignment
//
//  Created by Faisal Khan on 6/29/24.
//

import Foundation

struct MovieModel : Hashable,Codable {
    let imdbID:String
    let title:String
    let language:String
    let year:String
    let genre:String
    let actors:String
    let director:String
    let poster:String
    let plot:String
    let released:String
    let writer:String
    let ratings:[Ratings]
    
    enum CodingKeys:String,CodingKey {
        case imdbID  = "imdbID"
        case title = "Title"
        case language = "Language"
        case year = "Year"
        case genre = "Genre"
        case actors = "Actors"
        case director = "Director"
        case poster = "Poster"
        case plot = "Plot"
        case released = "Released"
        case writer = "Writer"
        case ratings = "Ratings"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
    
    static func ==(lhs:MovieModel,rhs:MovieModel)->Bool {
        lhs.imdbID == rhs.imdbID
    }
}

struct Ratings : Hashable,Codable {
    var source:String
    var value:String
    
    enum CodingKeys:String,CodingKey {
        case source  = "Source"
        case value = "Value"
    }
}
