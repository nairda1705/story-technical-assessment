import Foundation

struct UserStoriesPageDTO: Decodable {
  // MARK: - PROPERTIES

  let stories: [UserStoryDTO]
  let pageNumber: Int
  let isLastPage: Bool

  // MARK: - CODING KEYS

  private enum CodingKeys: String, CodingKey {
    case stories
    case pageNumber = "page_number"
    case isLastPage = "is_last_page"
  }
}
