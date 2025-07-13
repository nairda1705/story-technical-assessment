import SwiftUI

struct UserStoriesCarouselView: View {
  // MARK: - PRIVATE PROPERTIES

  @StateObject private var viewModel = UserStoriesCarouselViewModel(repository: MockedUserStoryRepository())

  // MARK: - VIEWS

  var body: some View {
    content
      .frame(maxWidth: .infinity, alignment: .center)
      .onAppear(perform: viewModel.handleOnAppear)
  }

  @ViewBuilder
  private var content: some View {
    if viewModel.model.isFetchingNextPage && viewModel.model.stories.isEmpty {
      LoadingSpinnerView()
        .frame(height: 16.0)
        .frame(maxWidth: .infinity, alignment: .center)
    } else {
      ScrollView(.horizontal) {
        LazyHStack(spacing: 16.0) {
          ForEach(viewModel.model.stories) { storyModel in
            let isLastStory = storyModel == viewModel.model.stories.last
            UserStoryCircleView(model: storyModel)
              .onAppear {
                if isLastStory { viewModel.handleOnLastStoryAppear() }
              }
          }
          if viewModel.model.isFetchingNextPage {
            LoadingSpinnerView()
              .frame(height: 16.0)
          }
        }
        .padding(.horizontal, 16.0)
      }
      .scrollIndicators(.never)
    }
  }
}
