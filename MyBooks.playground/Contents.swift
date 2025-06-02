import UIKit

// Dataset: Array of tuples for  five books on my book shelf
let books : [(title: String, pages: Int)] = [
    (title: "A Court of Thorns and Roses", pages: 419),
    (title: "A Court of Mist and Fury", pages: 624),
    (title: "A Court of Wings and Ruin", pages: 699),
    (title: "A Court of Frost and Starlight", pages: 232),
    (title: "A Court of Silver Flames", pages: 757),
]

// Function that returns a tuple with max, min, and average pages from the book array
func getBookStats(from bookList: [(title: String, pages: Int)]) -> (max: Int, min: Int, average: Double) {
    let pageNumbers = bookList.map { $0.pages }
    let maxPages = pageNumbers.max()!
    let minPages = pageNumbers.min()!
    let totalPages = pageNumbers.reduce(0, +)
    let averagePages = Double(totalPages) / Double(bookList.count)
    
    return (max: maxPages, min: minPages, average: averagePages)
}

//Filter function using a closure - books with more than 500 pages
func filterLongBooks(from bookList: [(title: String, pages: Int)]) -> [(title: String, pages: Int)] {
    return bookList.filter { $0.pages > 500 }
}

//Print OG data
print("All Books:")
for book in books {
    print("- \(book.title): \(book.pages) pages")
}

//Get and print the summary stats from the books
let stats = getBookStats(from: books)
print("\nSummary:")
print("Max pages: \(stats.max)")
print("Min pages: \(stats.min)")
print("Average pages: \(Int(stats.average))")

//Now filter out and print the books over 500 pages
let longBooks = filterLongBooks(from: books)
print("\nBooks over 500 pages:")
for book in longBooks {
    print("- \(book.title): \(book.pages) pages")
}

