import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var filterLabel: UILabel!
    
    private var nowShowingMovieService = MovieManager()
    private var filterMovieService = MovieManager()
    private var genresService = GenresManager()
    private var movieArray = [MovieModel]()
    private var filterMovieListArray = [MovieModel]()
    private var genresArray = [GenresModel]()
    private var request = String()
    private var selectedCell = MovieModel(movieID: 0, title: "", overview: "", poster: "",backdrop: "", date: "", vote: 0, genres: [0])
    private var fetchUrlDict = ["Popular" : "popular", "Upcoming" : "upcoming", "Top Rated" : "top_rated"]
    private var movieTypeArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let storedFilter = UserDefaults.standard.object(forKey: "filterType") as! String
        let newUrl = fetchUrlDict[storedFilter]!
        getFilterMovieList(re: newUrl)
        filterLabel.text = storedFilter
        filterMovieListArray.removeAll()
    }
    
    private func configureUI() {
        nowShowingMovieService.delegate = self
        filterMovieService.delegate = self
        genresService.delegate = self
        getNowPlayingMovie()
        genresService.fetchUrl()
        
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    private func getNowPlayingMovie() {
        nowShowingMovieService.fetchUrl(request: "now_playing")
    }
    
    private func getFilterMovieList(re: String) {
        request = re
        filterMovieService.fetchUrl(request: request)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! DetailsViewController
            destinationVC.choesenCell = selectedCell
        }
    }
}

// MARK: - MovieServiceDelegate
extension HomeViewController: MovieManagerDelegate {
    func didUpdateMovie(movies: [MovieModel]) {
        movieArray = movies
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func filterMovie(movies: [MovieModel]) {
        if nowShowingMovieService.page < 5 {
            nowShowingMovieService.page += 1
            nowShowingMovieService.fetchUrl(request: request)
        } else {nowShowingMovieService.page = 1}
        filterMovieListArray += movies
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - GenresServiceDelegate
extension HomeViewController: GenresManagerDelegate {
    func didUpdateGenres(genres: [GenresModel]) {
        genresArray = genres
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let movieItem = movieArray[indexPath.row]
        if let posterPathUrl = movieItem.poster {
            cell.configureMovieCell(movieTitle: movieItem.title, imageUrl: posterPathUrl, movieVote: movieItem.vote)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedCell = movieArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterMovieListArray.count > 20 { return 20 } else { return filterMovieListArray.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        if indexPath.row < 20 {
            let movieItem = filterMovieListArray[indexPath.row]
            movieTypeArr.removeAll()
            movieTypeArr = getMovieGenres(genresArray: genresArray, movieItem: movieItem)
            if let posterPathUrl = movieItem.poster {
                cell.configureTableView(titleMovie: movieItem.title, voteMovie: movieItem.vote, imageUrl: posterPathUrl, dateMovie: movieItem.date, movieTypeArray: movieTypeArr)
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCell = filterMovieListArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
}
