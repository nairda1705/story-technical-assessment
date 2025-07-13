import Combine
import Foundation

final class MockedUserStoryRepository: UserStoryRepository {
  // MARK: - NESTED TYPES

  private enum Constants {
    static let resourceName = "user_stories"
    static let jsonExtension = "json"
  }

  // MARK: - PUBLIC PROPERTIES

  var eventPublisher: AnyPublisher<UserStoryRepositoryEvent, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  // MARK: - PRIVATE PROPERTIES

  private let mapper = UserStoryRepositoryMapper()
  private let eventSubject = PassthroughSubject<UserStoryRepositoryEvent, Never>()

  private var allPages: UserStoriesPagesResponseDTO?

  // MARK: - PROTOCOL IMPLEMENTATION

  func fetchUserStoriesPage(page: Int) async throws(UserStoryError) -> UserStoriesPageDM {
    try? await Task.sleep(nanoseconds: 500_000_000) // Simulate a network call
    if allPages == nil {
      try await loadJSON()
    }
    guard
      page <= allPages?.pages.count ?? .zero,
      let dto = allPages?.pages[page - 1]
    else { throw .couldNotRetrieveData }
    return mapper.mapUserStoriesPage(from: dto)
  }

  func markStoryAsSeen(userID: Int, storyID: Int) async throws(UserStoryError) {
    try? await Task.sleep(nanoseconds: 500_000_000) // Simulate a network call
    let storyContent = (allPages?.pages ?? [])
      .flatMap { $0.page.stories }
      .first { $0.userID == userID }?
      .content
      .first { $0.id == storyID }
    let seenStoryContent = storyContent?.copy {
      $0.seen = true
    }
    guard
      let seenStoryContent,
      let newStoryContent = mapper.mapUserStoryContent(from: seenStoryContent)
    else { return }
    eventSubject.send(.markedAsSeen(newStoryContent))
  }

  func likeStory(userID: Int, storyID: Int) async throws(UserStoryError) {
    try? await Task.sleep(nanoseconds: 500_000_000) // Simulate a network call
    let storyContent = (allPages?.pages ?? [])
      .flatMap { $0.page.stories }
      .first { $0.userID == userID }?
      .content
      .first { $0.id == storyID }
    let likeToggledStoryContent = storyContent?.copy {
      $0.liked.toggle()
    }
    guard
      let likeToggledStoryContent,
      let newStoryContent = mapper.mapUserStoryContent(from: likeToggledStoryContent)
    else { return }
    eventSubject.send(.likeToggled(newStoryContent))
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
