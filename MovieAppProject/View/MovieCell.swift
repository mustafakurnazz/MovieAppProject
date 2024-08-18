import UIKit

final class MovieCell: UITableViewCell, UICollectionViewDelegate {

    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var vote: UILabel!
    @IBOutlet private weak var date: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var movieType = [String]()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "GenresCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GenresCollectionViewCell")
    }
    
    func configureTableView(titleMovie: String, voteMovie: Double, imageUrl: String, dateMovie: String, movieTypeArray: [String]) {
        collectionView.reloadData()
        movieType = movieTypeArray
        titleLabel.text = titleMovie
        let newVote = String(format: "%.1f", voteMovie)
        vote.text = "⭐" + newVote + "/10 IMDb"
        date.text = "🗓️" + dateMovie
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
              guard let imageData = data else { return }
              DispatchQueue.main.async {
                  self.movieImageView.image = UIImage(data: imageData)
              }
            }.resume()
        }
    }
}

extension MovieCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenresCollectionViewCell", for: indexPath) as! GenresCollectionViewCell
        let typeItem = movieType[indexPath.row]
        cell.configureMovieType(movieType: typeItem)
        return cell
    }
}
