import Foundation

//MARK: - CastData
struct CastData: Codable {
    let cast : [Cast]
}

struct Cast: Codable {
    let id : Int
    let original_name : String
    let profile_path : String?
    let character : String
}

//MARK: - PopularActorData
struct PopularActorData: Codable {
    let results : [ActorResults]
}

struct ActorResults: Codable {
    let id : Int
    let original_name : String
    let profile_path : String?
}

//MARK: - ActorDetailsData
struct ActorDetailsData: Codable {
    let biography : String
    let birthday : String
    let place_of_birth : String
    let movie_credits : movie_credits
}

struct movie_credits: Codable {
    let cast : [CastDetails]
}

struct CastDetails: Codable {
    let original_title : String
    let character : String
    let poster_path : String?
}
