import UIKit

final class SearchViewController: UIViewController, UISearchControllerDelegate {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let movieService = MovieManager()
    private var movieArray = [MovieModel]()
    private var searchedMovieArray = [MovieModel]()
    private let request = "popular"
    private let searchController = UISearchController()
    private var movieTypeArr = [String]()
    private var text = ""
    private var selectedMovie = MovieModel(movieID: 0, title: "", overview: "", poster: "", backdrop: "", date: "", vote: 0, genres: [0])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        movieService.delegate = self
        movieService.fetchUrl(request: request)
        
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchToMovieDetails" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.choesenCell = selectedMovie
        }
    }
}

//MARK: - MovieManagerDelegate
extension SearchViewController: MovieManagerDelegate {
    func didUpdateMovie(movies: [MovieModel]) {
    }
    
    func filterMovie(movies: [MovieModel]) {
        if movieService.page < 5 {
            movieService.page += 1
            movieService.fetchUrl(request: request)
        } else {movieService.page = 1}
        movieArray += movies
        print(movieArray.count)
    }
}

//MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchedMovieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movieItem = searchedMovieArray[indexPath.row]
        if let posterPathUrl = movieItem.poster {
            cell.configureTableView(titleMovie: movieItem.title, voteMovie: movieItem.vote, imageUrl: posterPathUrl, dateMovie: movieItem.date, movieTypeArray: movieTypeArr)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedMovie = searchedMovieArray[indexPath.row]
        performSegue(withIdentifier: "searchToMovieDetails", sender: nil)
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedMovieArray.removeAll()
        for count in 0 ... movieArray.count - 1 {
            if movieArray[count].title.contains(searchText) {
                searchedMovieArray.append(movieArray[count])
            }
        }
        text = searchText
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        text = ""
    }
}
