import UIKit

final class PopularActorViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var popularActorService = PopularActorManager()
    private var popularActorArr = [PopularActorModel]()
    private var selectedActor = PopularActorModel(id: 0, actorName: "", actorımage: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        popularActorService.delegate = self
        popularActorService.fetchUrl()
        
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
}

// MARK: - PopularActorManagerDelegate
extension PopularActorViewController: popularActorManagerDelegate {
    func didUpdatePopularActor(popularActorArray: [PopularActorModel]) {
        popularActorArr = popularActorArray
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toActorDetailsVC" {
            let destinationVC = segue.destination as! ActorDetailsViewController
            destinationVC.choesenPopularActor = selectedActor
        }
    }
}

//MARK: - CollecitonViewDataSource
extension PopularActorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularActorArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let actorItem = popularActorArr[indexPath.row]
        if let imageUrl = actorItem.actorımage {
            cell.configurePopularActorCell(actorName: actorItem.actorName, actorImageUrl: imageUrl)
        }
        return cell
    }
}

//MARK: - CollectionViewDelegate
extension PopularActorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedActor = popularActorArr[indexPath.row]
        performSegue(withIdentifier: "toActorDetailsVC", sender: nil)
    }
}
