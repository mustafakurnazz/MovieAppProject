import UIKit

final class ActorDetailsViewController: UIViewController {
    
    @IBOutlet private weak var actorName: UILabel!
    @IBOutlet private weak var birthdayLabel: UILabel!
    @IBOutlet private weak var actorImageView: UIImageView!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var birthdayPlace: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var choesenPopularActor = PopularActorModel(id: 0, actorName: "", actorımage: "")
    var choesenCastActor = CastModel(id: 0, actorName: "", actorImage: "", chracterName: "")
    private let actorDetailsService = ActorDetailsManager()
    private var actorDetailsArr = [ActorDetailsModel]()
    private var movieCount = Int()
    private var movieArr = [ActorMovieModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI(){
        actorDetailsService.delegate = self
        if choesenPopularActor.actorName != "" {
            actorDetailsService.fetchUrl(actorsId: choesenPopularActor.id)
            actorName.text = choesenPopularActor.actorName
            if let imageUrl = choesenPopularActor.actorımage {
                getImage(imageUrl: imageUrl)
            }
        }
        else{
            actorDetailsService.fetchUrl(actorsId: choesenCastActor.id)
            actorName.text = choesenCastActor.actorName
            if let imageUrl = choesenCastActor.actorImage {
                getImage(imageUrl: imageUrl)
            }
        }
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    private func getImage(imageUrl: String) {
        if let url = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
              guard let imageData = data else { return }
              DispatchQueue.main.async {
                  self.actorImageView.image = UIImage(data: imageData)
              }
            }.resume()
        }
    }
    
    private func configureLabel(bio: String, bday: String, placeOfBirth: String) {
        bioLabel.text = bio
        birthdayLabel.text = bday
        birthdayPlace.text = placeOfBirth
    }
}

//MARK: - ActorDetailsDelegate
extension ActorDetailsViewController: actorDetailsDelegate {
    func didUpdateActorDetails(actorDetailsArray: [ActorDetailsModel]) {
        actorDetailsArr = actorDetailsArray
        DispatchQueue.main.async {
            self.movieCount = actorDetailsArray[0].movieDetails.count
            self.movieArr = actorDetailsArray[0].movieDetails
            let bio = actorDetailsArray[0].biography
            let bday = actorDetailsArray[0].bday
            let placeOfBirth = actorDetailsArray[0].placeOfBirth
            self.configureLabel(bio: bio, bday: bday, placeOfBirth: placeOfBirth)
            self.collectionView.reloadData()
        }
    }
}

//MARK: - CollectionViewDataSource
extension ActorDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let movieItem = movieArr[indexPath.row]
        if let imageUrl = movieItem.movieImage {
            cell.configureCastCell(actorName: movieItem.movieName, actorImageUrl: imageUrl, chracterName: movieItem.character)
        }
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension ActorDetailsViewController: UICollectionViewDelegate {
    
}
