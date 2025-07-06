import Foundation

struct Destination {
    let name: String
    let country: String
    let description: String
    let bestTime: String
    var isVisited: Bool
    
    // Simple data array
    static var allDestinations = [
        Destination(name: "Paris", country: "France", description: "Beautiful city with Eiffel Tower and amazing art museums", bestTime: "Spring", isVisited: false),
        Destination(name: "Tokyo", country: "Japan", description: "Modern city with great food and cherry blossoms", bestTime: "Fall", isVisited: false),
        Destination(name: "New York", country: "USA", description: "The city that never sleeps with Broadway and Central Park", bestTime: "Summer", isVisited: true),
        Destination(name: "London", country: "UK", description: "Historic city with Big Ben and the Thames", bestTime: "Summer", isVisited: false),
        Destination(name: "Rome", country: "Italy", description: "Ancient city with Colosseum and Vatican", bestTime: "Spring", isVisited: false),
        Destination(name: "Sydney", country: "Australia", description: "Harbor city with Opera House and beautiful beaches", bestTime: "Spring", isVisited: false),
        Destination(name: "Barcelona", country: "Spain", description: "Art and architecture by the Mediterranean sea", bestTime: "Fall", isVisited: false),
        Destination(name: "Dubai", country: "UAE", description: "Luxury destination with modern skyscrapers", bestTime: "Winter", isVisited: false),
        Destination(name: "Bangkok", country: "Thailand", description: "Vibrant city with temples and street food", bestTime: "Winter", isVisited: false),
        Destination(name: "Cairo", country: "Egypt", description: "Ancient city with Pyramids and rich history", bestTime: "Winter", isVisited: false),
        Destination(name: "Rio de Janeiro", country: "Brazil", description: "Beach city famous for carnival and Christ statue", bestTime: "Summer", isVisited: false),
        Destination(name: "Mumbai", country: "India", description: "Bollywood capital with spicy food and culture", bestTime: "Winter", isVisited: false)
    ]
}
