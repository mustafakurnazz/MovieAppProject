import Foundation

protocol GenresManagerDelegate {
    func didUpdateGenres(genres: [GenresModel])
}

final class GenresManager {
    var delegate : GenresManagerDelegate?
    
    func fetchUrl() {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=ac18b0debc0444ad36fc1167a0a982e1"
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
                    if let genres = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdateGenres(genres: genres)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> [GenresModel]? {
        let decoder = JSONDecoder()
        var genresArray = [GenresModel]()
        
        do{
            let decodedData = try decoder.decode(GenresData.self, from: data)
            for count in (0 ... decodedData.genres.count - 1) {
                let id = decodedData.genres[count].id
                let name = decodedData.genres[count].name
                
                let genres = GenresModel(id: id, name: name)
                genresArray.append(genres)
            }
            return genresArray
            
        } catch {
            print(error)
            return nil
        }
    }
}
