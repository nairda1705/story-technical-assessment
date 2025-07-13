import Foundation

struct UserStoryRepositoryMapper {
  func mapUserStoriesPage(from dto: UserStoriesPageResponseDTO) -> UserStoriesPageDM {
    UserStoriesPageDM(
      stories: dto.page.stories.map(mapUserStory),
      isLastPage: dto.page.isLastPage
    )
  }

  private func mapUserStory(from dto: UserStoryDTO) -> UserStoryDM {
    let url: URL? = if let string = dto.userProfilePictureURL {
      URL(string: string)
    } else { nil }
    return UserStoryDM(
      userID: dto.userID,
      userName: dto.userName,
      userProfilePictureURL: url,
      content: dto.content.compactMap(mapUserStoryContent)
    )
  }

  private func mapUserStoryContent(from dto: UserStoryContentDTO) -> UserStoryContentDM? {
    guard let url = URL(string: dto.imageURL) else { return nil }
    return UserStoryContentDM(
      seen: dto.seen,
      duration: dto.duration,
      imageURL: url
    )
  }
}
