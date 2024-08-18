import UIKit

final class MovieCastViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    var castArray = [CastModel]()
    private var selectedCast = CastModel(id: 0, actorName: "", actorImage: "", chracterName: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieCastToActorDetailsVC" {
            let destinationVC = segue.destination as! ActorDetailsViewController
            destinationVC.choesenCastActor = selectedCast
        }
    }
}

//MARK: - UICollectionViewDataSource
extension MovieCastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let castItem = castArray[indexPath.row]
        if let imageUrl = castItem.actorImage {
            cell.configureCastCell(actorName: castItem.actorName, actorImageUrl: imageUrl, chracterName: castItem.chracterName)
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension MovieCastViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedCast = castArray[indexPath.row]
        performSegue(withIdentifier: "movieCastToActorDetailsVC", sender: nil)
    }
}
