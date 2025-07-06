import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView!
    private var destinations = Destination.allDestinations
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Travel Destinations"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        // Create table view
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        
        // Register cell - this is CRITICAL
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DestinationCell")
        
        // Add to view
        view.addSubview(tableView)
        
        // Set constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath)
        
        let destination = destinations[indexPath.row]
        
        // Configure cell - use subtitle style
        cell.textLabel?.text = destination.name
        cell.detailTextLabel?.text = destination.country
        
        // Show checkmark if visited
        cell.accessoryType = destination.isVisited ? .checkmark : .disclosureIndicator
        
        // Style the labels
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.textColor = .systemBlue
        
        return cell
    }
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Navigate to detail view
        let destination = destinations[indexPath.row]
        let detailViewController = DetailViewController()
        detailViewController.destination = destination
        detailViewController.destinationIndex = indexPath.row
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: - Swipe Actions
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Mark as visited action
        let visitAction = UIContextualAction(style: .normal, title: destinations[indexPath.row].isVisited ? "Unvisit" : "Visit") { [weak self] (action, view, completion) in
            self?.destinations[indexPath.row].isVisited.toggle()
            Destination.allDestinations[indexPath.row].isVisited.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        visitAction.backgroundColor = destinations[indexPath.row].isVisited ? .systemOrange : .systemGreen
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
            self?.showDeleteConfirmation(for: indexPath)
            completion(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, visitAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Info action
        let infoAction = UIContextualAction(style: .normal, title: "Info") { [weak self] (action, view, completion) in
            let destination = self?.destinations[indexPath.row]
            self?.showQuickInfo(for: destination)
            completion(true)
        }
        infoAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [infoAction])
    }
    
    // MARK: - Helper Methods
    private func showDeleteConfirmation(for indexPath: IndexPath) {
        let destination = destinations[indexPath.row]
        let alert = UIAlertController(
            title: "Delete Destination",
            message: "Are you sure you want to delete \(destination.name)?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.destinations.remove(at: indexPath.row)
            Destination.allDestinations.remove(at: indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        })
        
        present(alert, animated: true)
    }
    
    private func showQuickInfo(for destination: Destination?) {
        guard let destination = destination else { return }
        
        let alert = UIAlertController(
            title: destination.name,
            message: "Country: \(destination.country)\nBest time to visit: \(destination.bestTime)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
