struct UserStoryContentDTO: Decodable {
  // MARK: - PROPERTIES

  let seen: Bool
  let duration: Int
  let imageURL: String

  // MARK: - CODING KEYS

  private enum CodingKeys: String, CodingKey {
    case seen
    case duration
    case imageURL = "image_url"
  }
}
