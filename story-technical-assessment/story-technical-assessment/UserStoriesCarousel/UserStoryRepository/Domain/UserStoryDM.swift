import Foundation

struct UserStoryDM {
  let userID: Int
  let userName: String
  let userProfilePictureURL: URL?
  let content: [UserStoryContentDM]
}
