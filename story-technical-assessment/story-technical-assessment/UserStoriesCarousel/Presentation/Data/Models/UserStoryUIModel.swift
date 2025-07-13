import Foundation

struct UserStoryUIModel: Identifiable, Hashable {
  var id: Int { userID }

  let userID: Int
  let userName: String
  let profilePictureURL: URL?

  init(
    userID: Int,
    userName: String,
    profilePictureURL: URL?
  ) {
    self.userID = userID
    self.userName = userName
    self.profilePictureURL = profilePictureURL
  }
}
