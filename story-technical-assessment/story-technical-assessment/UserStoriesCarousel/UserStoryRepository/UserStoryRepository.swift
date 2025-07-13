protocol UserStoryRepository {
  func fetchUserStoriesPage(page: Int) async throws(UserStoryError) -> UserStoriesPageDM
}
