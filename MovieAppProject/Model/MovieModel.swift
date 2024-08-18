import Foundation

struct MovieModel: Codable {
    let movieID : Int
    let title : String
    let overview : String
    let poster : String?
    let backdrop : String?
    let date : String
    let vote : Double
    let genres : [Int]
}
