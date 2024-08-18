import UIKit

extension UIViewController{
    func getMovieGenres(genresArray: [GenresModel], movieItem: MovieModel) -> [String] {
        var movieTypeArr = [String]()
        for j in stride(from: 0, through: genresArray.count - 1, by: 1) {
            for i in (0 ... movieItem.genres.count - 1) {
                if genresArray[j].id == movieItem.genres[i] {
                    movieTypeArr.append(genresArray[j].name)
                }
            }
        }
        return movieTypeArr
    }
    
}
