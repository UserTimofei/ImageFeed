@testable import ImageFeed


extension Profile {
    static func stub(
        username: String = "test",
        name: String = "Test User",
        loginName: String = "@test",
        bio: String? = "Bio"
    ) -> Profile {
        return Profile(username: username, name: name, loginName: loginName, bio: bio)
    }
}
