import UIKit

class GenresCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var typeLabel: UILabel!
    
    func configureMovieType(movieType: String) {
        self.typeLabel.layer.cornerRadius = 58
        self.typeLabel.layer.masksToBounds = true
        typeLabel.text = movieType
    }
}
