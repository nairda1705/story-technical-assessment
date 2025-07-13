protocol UserStoryRepository {
  func fetchUserStoriesPage(page: Int) async throws(UserStoryError) -> UserStoriesPageDM
}

import Foundation

struct UserStoryRepositoryMapper {
  func mapUserStoriesPage(from dto: UserStoriesPageResponseDTO) -> UserStoriesPageDM {
    UserStoriesPageDM(
      stories: dto.page.stories.map(mapUserStory),
      isLastPage: dto.page.isLastPage
    )
  }

  private func mapUserStory(from dto: UserStoryDTO) -> UserStoryDM {
    let url = URL(string: dto.userProfilePictureURL)
    return UserStoryDM(
      userID: dto.userID,
      userName: dto.userName,
      userProfilePictureURL: url
    )
  }
}

final class MockedUserStoryRepository: UserStoryRepository {
  // MARK: - NESTED TYPES

  private enum Constants {
    static let resourceName = "user_stories"
    static let jsonExtension = "json"
  }

  // MARK: - PRIVATE PROPERTIES

  private let mapper = UserStoryRepositoryMapper()

  private var allPages: UserStoriesPagesResponseDTO?

  // MARK: - PROTOCOL IMPLEMENTATION

  func fetchUserStoriesPage(page: Int) async throws(UserStoryError) -> UserStoriesPageDM {
    if allPages == nil {
      try await loadJSON()
    }
    guard
      page <= allPages?.pages.count ?? .zero,
      let dto = allPages?.pages[page - 1]
    else { throw .couldNotRetrieveData }
    return mapper.mapUserStoriesPage(from: dto)
  }

  // MARK: - PRIVATE METHODS

  private func loadJSON() async throws(UserStoryError) {
    guard
      let url = Bundle.main.url(forResource: Constants.resourceName, withExtension: Constants.jsonExtension),
      let data = try? Data(contentsOf: url)
    else {
      throw .couldNotRetrieveData
    }

    do {
      let decoded = try JSONDecoder().decode(UserStoriesPagesResponseDTO.self, from: data)
      allPages = decoded
    } catch {
      throw .failedDecoding
    }
  }
}

struct UserStoriesPageResponseDTO: Decodable {
  let page: UserStoriesPageDTO
}

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

struct UserStoryDTO: Decodable {
  // MARK: - PROPERTIES

  let userID: Int
  let userName: String
  let userProfilePictureURL: String

  // MARK: - CODING KEYS

  private enum CodingKeys: String, CodingKey {
    case userID = "id"
    case userName = "name"
    case userProfilePictureURL = "profile_picture_url"
  }
}

struct UserStoriesPagesResponseDTO: Decodable {
  let pages: [UserStoriesPageResponseDTO]
}

struct UserStoriesPageDM {
  let stories: [UserStoryDM]
  let isLastPage: Bool
}

struct UserStoryDM {
  let userID: Int
  let userName: String
  let userProfilePictureURL: URL?
}

enum UserStoryError: Error {
  case couldNotRetrieveData
  case failedDecoding
}
