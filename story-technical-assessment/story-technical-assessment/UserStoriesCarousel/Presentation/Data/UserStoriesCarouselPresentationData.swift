struct UserStoriesCarouselPresentationData {
  var currentPage: Int
  var pages: [UserStoriesPageDM]

  init(
    currentPage: Int = .zero,
    pages: [UserStoriesPageDM] = []
  ) {
    self.currentPage = currentPage
    self.pages = pages
  }
}
