import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var addButtonOutlet: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var seeMoreButtonOutlet: UIButton!
    
    var choesenCell = MovieModel(movieID: 0, title: "", overview: "", poster: "", backdrop: "", date: "", vote: 0, genres: [0])
    private var castService = CastManager()
    private var favouriteMovieArray = [MovieModel]()
    private var castArr = [CastModel]()
    private var defaults = UserDefaults.standard
    private var selectedCast = CastModel(id: 0, actorName: "", actorImage: "", chracterName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        seeMoreButtonOutlet.layer.cornerRadius = seeMoreButtonOutlet.frame.height / 2
        seeMoreButtonOutlet.backgroundColor = UIColor.blue
        seeMoreButtonOutlet.clipsToBounds = true
        seeMoreButtonOutlet.tintColor = UIColor.white
        
        if let data = defaults.data(forKey: "favMovies") {
            do {
                let decoder = JSONDecoder()
                let notes = try decoder.decode([MovieModel].self, from: data)
                favouriteMovieArray = notes
            } catch {
                print("Code could not be decoded \(error)")
            }
        }
        castService.delegate = self
        castService.fetchUrl(movieID: choesenCell.movieID)
        
        titleLabel.text = choesenCell.title
        overviewLabel.text = choesenCell.overview
        let newVote = String(format: "%.1f", choesenCell.vote)
        voteLabel.text = "⭐" + newVote + "/10 IMDb"
        dateLabel.text = "🗓️" + choesenCell.date
        if let imageUrl = choesenCell.backdrop{
            if let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                  guard let imageData = data else { return }
                  DispatchQueue.main.async {
                      self.movieImageView.image = UIImage(data: imageData)
                  }
                }.resume()
            }
        }
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    @IBAction private func addButtonTapped(_ sender: UIButton) {
        if !favouriteMovieArray.contains(where: {$0.movieID == choesenCell.movieID}) {
            favouriteMovieArray.append(choesenCell)
            
        } else {
            if let index = self.favouriteMovieArray.firstIndex(where: {$0.title == choesenCell.title}) {
                favouriteMovieArray.remove(at: index)
            }
        }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self.favouriteMovieArray)
            self.defaults.set(data, forKey: "favMovies")
            print(data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toSeeMoreCast", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSeeMoreCast" {
            let destinationVC = segue.destination as! MovieCastViewController
            destinationVC.castArray = castArr
        } else if segue.identifier == "castToActorDetailsVC" {
            let destinationVC = segue.destination as! ActorDetailsViewController
            destinationVC.choesenCastActor = selectedCast
        }
    }
    
}

//MARK: - CastManagerDelegate
extension DetailsViewController: castManagerDelegate {
    func didUpdateCast(castArray: [CastModel]) {
        castArr = castArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if castArr.count >= 5 {
            return 5
        } else {return castArr.count}
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let castItem = castArr[indexPath.row]
        if let imageUrl = castItem.actorImage {
            cell.configureCastCell(actorName: castItem.actorName, actorImageUrl: imageUrl, chracterName: castItem.chracterName)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedCast = castArr[indexPath.row]
        performSegue(withIdentifier: "castToActorDetailsVC", sender: nil)
    }
}
