import Foundation

struct UserStoryUIModel: Identifiable, Hashable {
  // MARK: - NESTED TYPES

  struct Content: Hashable {
    let seen: Bool
    let imageURL: URL
    let duration: Int
  }

  // MARK: - PUBLIC PROPERTIES

  var id: Int { userID }

  let userID: Int
  let userName: String
  let profilePictureURL: URL?
  let content: [Content]

  // MARK: - INIT

  init(
    userID: Int,
    userName: String,
    profilePictureURL: URL?,
    content: [Content]
  ) {
    self.userID = userID
    self.userName = userName
    self.profilePictureURL = profilePictureURL
    self.content = content
  }
}
