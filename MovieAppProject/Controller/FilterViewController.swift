import UIKit

final class FilterViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let filterArray = ["Popular", "Top Rated", "Upcoming"]
    private var selectedCell = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = filterArray[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelgate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCell = filterArray[indexPath.row]
        UserDefaults.standard.set(selectedCell, forKey: "filterType")
        self.navigationController?.popToRootViewController(animated: true)
    }
}
