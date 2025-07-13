import Foundation

struct UserStoryDTO: Decodable {
  // MARK: - PROPERTIES

  let userID: Int
  let userName: String
  let userProfilePictureURL: String?
  let content: [UserStoryContentDTO]

  // MARK: - CODING KEYS

  private enum CodingKeys: String, CodingKey {
    case userID = "id"
    case userName = "name"
    case userProfilePictureURL = "profile_picture_url"
    case content
  }
}
