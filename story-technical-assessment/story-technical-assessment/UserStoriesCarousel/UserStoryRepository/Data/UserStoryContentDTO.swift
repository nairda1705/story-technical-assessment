struct UserStoryContentDTO: Decodable, MutableByCopy {
  // MARK: - PROPERTIES

  let id: Int
  var seen: Bool
  var liked: Bool
  let duration: Int
  let imageURL: String

  // MARK: - CODING KEYS

  private enum CodingKeys: String, CodingKey {
    case id
    case seen
    case liked
    case duration
    case imageURL = "image_url"
  }
}
