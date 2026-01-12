@testable import ImageFeed
import Foundation
import CoreGraphics

extension Photo {
    static func stub(
        id: String = "test-id",
        size: CGSize = CGSize(width: 300, height: 300),
        createdAt: Date? = Date(),
        welcomeDescription: String? = "Test photo",
        thumbImageURL: String = "https://example.com/thumb.jpg",
        largeImageURL: String = "https://example.com/large.jpg",
        isLiked: Bool = false
    ) -> Photo {
        Photo(
            id: id,
            size: size,
            createdAt: createdAt,
            welcomeDescription: welcomeDescription,
            thumbImageURL: thumbImageURL,
            largeImageURL: largeImageURL,
            isLiked: isLiked
        )
    }
}
