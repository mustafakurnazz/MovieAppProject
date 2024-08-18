import UIKit

final class FavouriteListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var favouriteMovieArr = [MovieModel]()
    private var defaults = UserDefaults.standard
    private var selectedCell = MovieModel(movieID: 0, title: "", overview: "", poster: "", backdrop: "", date: "", vote: 0, genres: [0])
    private var movieTypeArr = [String]()
    private var genresArr = [GenresModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI()
    }
    
    private func configureUI() {
        if let data = defaults.data(forKey: "favMovies") {
            do {
                let decoder = JSONDecoder()
                let notes = try decoder.decode([MovieModel].self, from: data)
                favouriteMovieArr = notes
            } catch {
                print("Code could not be decoded \(error)")
            }
        }
                
        tableView.reloadData()
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.choesenCell = selectedCell
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            let addFavouriteAction = UIContextualAction(style: .normal, title: "Favorilerden Çıkar") { action, view, completionHandler in
                
                if self.favouriteMovieArr.contains(where: {$0.movieID == self.favouriteMovieArr[indexPath.row].movieID}) {
                    if let index = self.favouriteMovieArr.firstIndex(where: {$0.movieID == self.favouriteMovieArr[indexPath.row].movieID}) {
                        self.favouriteMovieArr.remove(at: index)
                        completionHandler(true)
                    }
                }
                
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(self.favouriteMovieArr)
                    self.defaults.set(data, forKey: "favMovies")
                    print(data)
                } catch {
                    print(error.localizedDescription)
                }
                
                self.tableView.reloadData()
            }
            
            addFavouriteAction.backgroundColor = UIColor.red
            let swipeConfiguration = UISwipeActionsConfiguration(actions: [addFavouriteAction])
            return swipeConfiguration
    }
}

// MARK: - UITableViewDataSource
extension FavouriteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteMovieArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieItem = favouriteMovieArr[indexPath.row]
        movieTypeArr.removeAll()
        movieTypeArr = getMovieGenres(genresArray: genresArr, movieItem: movieItem)
        if let posterPathUrl = movieItem.poster {
            cell.configureTableView(titleMovie: movieItem.title, voteMovie: movieItem.vote, imageUrl: posterPathUrl, dateMovie: movieItem.date, movieTypeArray: movieTypeArr)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension FavouriteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCell = favouriteMovieArr[indexPath.row]
        performSegue(withIdentifier: "listToDetailsVC", sender: nil)
    }
}
