import Foundation

protocol MovieManagerDelegate {
    func didUpdateMovie(movies: [MovieModel])
    func filterMovie(movies: [MovieModel])
}

final class MovieManager {
    var delegate : MovieManagerDelegate?
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private var movieImage = String()
    private var posterPath = String()
    private var requestUrl = String()
    var page = 1
    
    func fetchUrl(request: String) {
        requestUrl = request
        let urlString = "https://api.themoviedb.org/3/movie/\(request)?api_key=ac18b0debc0444ad36fc1167a0a982e1&page=\(page)"
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
                    if let movies = self.parseJSON(data: safeData) {
                        if self.requestUrl == "now_playing" {self.delegate?.didUpdateMovie(movies: movies)}
                        else {self.delegate?.filterMovie(movies: movies)}
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> [MovieModel]?  {
        let decoder = JSONDecoder()
        var movieArray = [MovieModel]()
        
        do{
            let decodedData = try decoder.decode(MovieData.self, from: data)
            for count in (0 ... decodedData.results.count - 1) {
                let id = decodedData.results[count].id
                let title = decodedData.results[count].original_title
                let oveerview = decodedData.results[count].overview
                if let posterPathUrl = decodedData.results[count].poster_path {
                    posterPath = imageUrl + posterPathUrl
                }
                if let movieImageUrl = decodedData.results[count].backdrop_path {
                    movieImage = imageUrl + movieImageUrl
                }
                let date = decodedData.results[count].release_date
                let vote = decodedData.results[count].vote_average
                let genres = decodedData.results[count].genre_ids
                
                let movie = MovieModel(movieID: id, title: title, overview: oveerview, poster: posterPath, backdrop: movieImage, date: date, vote: vote, genres: genres)
                movieArray.append(movie)
            }
            return movieArray
            
        } catch {
            print(error)
            return nil
        }
    }
}
