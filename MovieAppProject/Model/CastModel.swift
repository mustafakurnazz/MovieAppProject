import Foundation

//MARK: - CastModel
struct CastModel: Codable {
    let id : Int
    let actorName : String
    let actorImage : String?
    let chracterName : String
}

//MARK: - PopularActorModel
struct PopularActorModel: Codable {
    let id : Int
    let actorName : String
    let actorımage : String?
}

//MARK: - ActorDetailsModel
struct ActorDetailsModel: Codable {
    let biography : String
    let bday : String
    let placeOfBirth : String
    let movieDetails : [ActorMovieModel]
}

struct ActorMovieModel: Codable {
    let movieName : String
    let character : String
    let movieImage : String?
}
