import Foundation

struct UserStoriesCarouselUIMapper {
  func mapUserStories(from userStories: [UserStoryDM]) -> [UserStoryUIModel] {
    userStories.map { userStory in
      UserStoryUIModel(
        userID: userStory.userID,
        userName: userStory.userName,
        profilePictureURL: userStory.userProfilePictureURL
      )
    }
  }
}
