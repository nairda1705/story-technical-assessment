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
