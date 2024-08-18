import Foundation

protocol popularActorManagerDelegate {
    func didUpdatePopularActor(popularActorArray: [PopularActorModel])
}

final class PopularActorManager {
    var delegate : popularActorManagerDelegate?
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private var actorImageUrl = String()
    
    func fetchUrl() {
        let urlString = "https://api.themoviedb.org/3/person/popular?api_key=ac18b0debc0444ad36fc1167a0a982e1"
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
                        self.delegate?.didUpdatePopularActor(popularActorArray: actors)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(data: Data) -> [PopularActorModel]? {
        let decoder = JSONDecoder()
        var popularActorArray = [PopularActorModel]()
        
        do{
            let decodedData = try decoder.decode(PopularActorData.self, from: data)
            for count in (0 ... decodedData.results.count - 1) {
                let id = decodedData.results[count].id
                let actorName = decodedData.results[count].original_name
                if let actorImage = decodedData.results[count].profile_path {
                    actorImageUrl = imageUrl + actorImage
                }
                
                let actor = PopularActorModel(id: id, actorName: actorName, actorımage: actorImageUrl)
                popularActorArray.append(actor)
            }
            return popularActorArray
            
        } catch {
            print(error)
            return nil
        }

    }
}
