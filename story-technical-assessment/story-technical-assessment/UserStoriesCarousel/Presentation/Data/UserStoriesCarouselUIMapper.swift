import Foundation

struct UserStoriesCarouselUIMapper {
  func mapUserStories(from userStories: [UserStoryDM]) -> [UserStoryUIModel] {
    userStories.map { userStory in
      UserStoryUIModel(
        userID: userStory.userID,
        userName: userStory.userName,
        profilePictureURL: userStory.userProfilePictureURL,
        content: userStory.content.map(mapUserStoriesContent)
      )
    }
  }

  private func mapUserStoriesContent(from userStoryContent: UserStoryContentDM) -> UserStoryUIModel.Content {
    UserStoryUIModel.Content(
      seen: userStoryContent.seen,
      imageURL: userStoryContent.imageURL,
      duration: userStoryContent.duration
    )
  }
}
