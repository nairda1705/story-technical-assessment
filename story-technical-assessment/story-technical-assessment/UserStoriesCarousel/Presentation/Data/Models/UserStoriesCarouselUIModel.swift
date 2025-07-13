struct UserStoriesCarouselUIModel {
  var stories: [UserStoryUIModel]
  var isFetchingNextPage: Bool

  init(
    stories: [UserStoryUIModel] = [],
    isFetchingNextPage: Bool = false
  ) {
    self.stories = stories
    self.isFetchingNextPage = isFetchingNextPage
  }
}
