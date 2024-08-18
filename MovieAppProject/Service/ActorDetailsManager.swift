import Foundation

protocol actorDetailsDelegate {
    func didUpdateActorDetails(actorDetailsArray: [ActorDetailsModel])
}

final class ActorDetailsManager {
    var delegate : actorDetailsDelegate?
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private var movieImageUrl = String()
    
    func fetchUrl(actorsId: Int) {
        let urlString = "https://api.themoviedb.org/3/person/\(actorsId)?api_key=ac18b0debc0444ad36fc1167a0a982e1&append_to_response=movie_credits"
        if let url = URL(string: urlString) {
            self.performRequest(url: url)
        }
    }
    
    private func performRequest(url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {print(error!.localizedDescription)}
            else {
                if let safeData = data {
                    if let actors = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdateActorDetails(actorDetailsArray: actors)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> [ActorDetailsModel]? {
        let decoder = JSONDecoder()
        var actorsArray = [ActorDetailsModel]()
        var movieDetailsArray = [ActorMovieModel]()
        do{
            let decodedData = try decoder.decode(ActorDetailsData.self, from: data)
            let biography = decodedData.biography
            let birthday = decodedData.birthday
            let placeOfBirth = decodedData.place_of_birth
            for count in (0 ... decodedData.movie_credits.cast.count - 1) {
                let movieName = decodedData.movie_credits.cast[count].original_title
                let chracterName = decodedData.movie_credits.cast[count].character
                if let movieImage = decodedData.movie_credits.cast[count].poster_path {
                    movieImageUrl = imageUrl + movieImage
                }
                
                let movieDetails = ActorMovieModel(movieName: movieName, character: chracterName, movieImage: movieImageUrl)
                movieDetailsArray.append(movieDetails)
            }
            let actorDetails = ActorDetailsModel(biography: biography, bday: birthday, placeOfBirth: placeOfBirth, movieDetails: movieDetailsArray)
            actorsArray.append(actorDetails)
            return actorsArray
            
        } catch {
            print(error)
            return nil
        }

    }
}
