import UIKit

final class CollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var vote: UILabel!
    
    func configureMovieCell(movieTitle: String, imageUrl: String, movieVote: Double) {
        title.text = movieTitle
        let newVote = String(format: "%.1f", movieVote)
        vote.text = "⭐" + newVote + "/10 IMDb"
        getImage(imageUrl: imageUrl)
    }
    
    func configureCastCell(actorName: String, actorImageUrl: String, chracterName: String) {
        title.text = actorName
        vote.text = chracterName
        getImage(imageUrl: actorImageUrl)
    }
    
    func configurePopularActorCell(actorName: String, actorImageUrl: String) {
        title.text = actorName
        vote.isHidden = true
        getImage(imageUrl: actorImageUrl)
    }
    
    private func getImage(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
              guard let imageData = data else { return }
              DispatchQueue.main.async {
                  self.imageView.image = UIImage(data: imageData)
              }
            }.resume()
        }
    }
}
