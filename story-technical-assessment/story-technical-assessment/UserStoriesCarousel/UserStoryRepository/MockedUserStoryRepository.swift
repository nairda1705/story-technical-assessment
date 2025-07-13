import Foundation

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
