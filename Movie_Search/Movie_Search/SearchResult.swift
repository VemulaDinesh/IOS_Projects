// SearchResult.swift

import Foundation

// SearchResult.swift



struct SearchResult: Codable {
    
    let Search: [SearchItem]

}

struct SearchItem: Codable {
    let poster: String
    let title: String
    let type: String
    let year: String
    let imdbID: String

    enum CodingKeys: String, CodingKey {
        case poster = "Poster"
        case title = "Title"
        case type = "Type"
        case year = "Year"
        case imdbID
    }
}

