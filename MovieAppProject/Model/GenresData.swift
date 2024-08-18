import Foundation

struct GenresData: Codable {
    let genres : [Genres]
}

struct Genres: Codable {
    let id : Int
    let name : String
}
