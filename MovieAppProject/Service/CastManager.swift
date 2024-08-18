import Foundation

protocol castManagerDelegate {
    func didUpdateCast(castArray: [CastModel])
}

final class CastManager {
    var delegate : castManagerDelegate?
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private var actorImageUrl = String()
    
    func fetchUrl(movieID: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=ac18b0debc0444ad36fc1167a0a982e1"
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
                    if let cast = self.parseJSON(data: safeData) {
                        self.delegate?.didUpdateCast(castArray: cast)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> [CastModel]? {
        let decoder = JSONDecoder()
        var castArray = [CastModel]()
        
        do{
            let decodedData = try decoder.decode(CastData.self, from: data)
            for count in (0 ... decodedData.cast.count - 1) {
                let id = decodedData.cast[count].id
                let actorName = decodedData.cast[count].original_name
                if let actorImage = decodedData.cast[count].profile_path {
                    actorImageUrl = imageUrl + actorImage
                }
                let chracterName = decodedData.cast[count].character
                
                let cast = CastModel(id: id, actorName: actorName, actorImage: actorImageUrl, chracterName: chracterName)
                castArray.append(cast)
            }
            return castArray
            
        } catch {
            print(error)
            return nil
        }

    }
}
