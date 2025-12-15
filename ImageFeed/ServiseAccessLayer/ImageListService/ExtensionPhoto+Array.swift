import Foundation

extension Photo {
    init(from result: PhotoResult) {
        self.id = result.id
        
        let formatted = ISO8601DateFormatter()
        self.createdAt = formatted.date(from: result.createdAt)
        
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
        self.size = .zero
    }
}


extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> Array {
        guard index >= 0 && index < count else {
            fatalError("Index out of bounds: \(index)")
        }
        var copy = self
        copy[index] = newValue
        return copy
    }
}
