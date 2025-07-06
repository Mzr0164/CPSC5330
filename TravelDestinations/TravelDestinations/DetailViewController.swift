import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var nameLabel: UILabel!
    private var countryLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var bestTimeLabel: UILabel!
    private var visitedStatusLabel: UILabel!
    private var visitButton: UIButton!
    
    var destination: Destination?
    var destinationIndex: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateContent()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Details"
        
        setupScrollView()
        setupLabels()
        setupButton()
        setupConstraints()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
    }
    
    private func setupLabels() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        countryLabel = UILabel()
        countryLabel.font = UIFont.systemFont(ofSize: 20)
        countryLabel.textColor = .systemBlue
        countryLabel.textAlignment = .center
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        bestTimeLabel = UILabel()
        bestTimeLabel.font = UIFont.systemFont(ofSize: 16)
        bestTimeLabel.textColor = .systemGreen
        
        visitedStatusLabel = UILabel()
        visitedStatusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        visitedStatusLabel.textAlignment = .center
        
        [nameLabel, countryLabel, descriptionLabel, bestTimeLabel, visitedStatusLabel].forEach {
            $0?.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0!)
        }
    }
    
    private func setupButton() {
        visitButton = UIButton(type: .system)
        visitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        visitButton.layer.cornerRadius = 12
        visitButton.translatesAutoresizingMaskIntoConstraints = false
        visitButton.addTarget(self, action: #selector(visitButtonTapped), for: .touchUpInside)
        contentView.addSubview(visitButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            countryLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            countryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: countryLabel.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            bestTimeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            bestTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bestTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            visitedStatusLabel.topAnchor.constraint(equalTo: bestTimeLabel.bottomAnchor, constant: 20),
            visitedStatusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            visitedStatusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            visitButton.topAnchor.constraint(equalTo: visitedStatusLabel.bottomAnchor, constant: 30),
            visitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            visitButton.widthAnchor.constraint(equalToConstant: 200),
            visitButton.heightAnchor.constraint(equalToConstant: 50),
            visitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func updateContent() {
        guard let destination = destination else { return }
        
        nameLabel.text = destination.name
        countryLabel.text = destination.country
        descriptionLabel.text = destination.description
        bestTimeLabel.text = "🗓 Best time to visit: \(destination.bestTime)"
        
        updateVisitedStatus()
    }
    
    private func updateVisitedStatus() {
        guard let destination = destination else { return }
        
        if destination.isVisited {
            visitedStatusLabel.text = "✅ You have visited this destination"
            visitedStatusLabel.textColor = .systemGreen
            visitButton.setTitle("Mark as Not Visited", for: .normal)
            visitButton.backgroundColor = .systemRed
            visitButton.setTitleColor(.white, for: .normal)
        } else {
            visitedStatusLabel.text = "❌ You haven't visited this destination yet"
            visitedStatusLabel.textColor = .systemRed
            visitButton.setTitle("Mark as Visited", for: .normal)
            visitButton.backgroundColor = .systemGreen
            visitButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc private func visitButtonTapped() {
        guard let destinationIndex = destinationIndex else { return }
        
        // Update both local and global data
        destination?.isVisited.toggle()
        Destination.allDestinations[destinationIndex].isVisited.toggle()
        
        updateVisitedStatus()
        
        let message = destination?.isVisited == true ? "Marked as visited! 🎉" : "Removed from visited destinations"
        let alert = UIAlertController(title: "Updated", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
