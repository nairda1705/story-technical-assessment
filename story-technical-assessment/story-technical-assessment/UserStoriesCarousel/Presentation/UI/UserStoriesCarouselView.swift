import SwiftUI

struct UserStoriesCarouselView: View {
  // MARK: - PRIVATE PROPERTIES

  @StateObject private var viewModel = UserStoriesCarouselViewModel(repository: MockedUserStoryRepository())

  @Namespace private var animation

  @State private var selectedStory: UserStoryUIModel?

  private var fullscreenBinding: Binding<Bool> {
    Binding(get: {
      selectedStory != nil
    }, set: { isFullscreen in
      if !isFullscreen { selectedStory = nil }
    })
  }

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
      ScrollViewReader { proxy in
        ScrollView(.horizontal) {
          LazyHStack(spacing: 16.0) {
            ForEach(viewModel.model.stories) { storyModel in
              let isLastStory = storyModel == viewModel.model.stories.last
              UserStoryCircleView(model: storyModel)
                .onAppear {
                  if isLastStory { viewModel.handleOnLastStoryAppear() }
                }
                .onTapGesture { selectedStory = storyModel }
                .id(storyModel.id)
                .matchedTransitionSource(id: storyModel.id, in: animation)
            }
            if viewModel.model.isFetchingNextPage {
              LoadingSpinnerView()
                .frame(height: 16.0)
            }
          }
          .padding(.horizontal, 16.0)
        }
        .scrollIndicators(.never)
        .scrollClipDisabled()
        .onChange(of: selectedStory) {
          if let selectedStory { proxy.scrollTo(selectedStory.id) }
        }
        .sheet(isPresented: fullscreenBinding) {
          let viewModel = viewModel.makeUserStoriesFullscreenViewModel(with: selectedStory)
          UserStoriesFullscreenView(viewModel: viewModel, selectedStory: $selectedStory)
            .navigationTransition(.zoom(sourceID: selectedStory?.userID, in: animation))
        }
      }
    }
  }
}
