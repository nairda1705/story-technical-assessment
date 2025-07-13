import Combine

enum UserStoryRepositoryEvent {
  case markedAsSeen(UserStoryContentDM)
  case likeToggled(UserStoryContentDM)
}

protocol UserStoryRepository {
  var eventPublisher: AnyPublisher<UserStoryRepositoryEvent, Never> { get }

  func fetchUserStoriesPage(page: Int) async throws(UserStoryError) -> UserStoriesPageDM
  func markStoryAsSeen(userID: Int, storyID: Int) async throws(UserStoryError)
  func likeStory(userID: Int, storyID: Int) async throws(UserStoryError)
}
