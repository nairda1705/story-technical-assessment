import SwiftUI

struct UserStoriesFullscreenView: View {
  // MARK: - PRIVATE PROPERTIES

  @StateObject var viewModel: UserStoriesFullscreenViewModel
  @Binding var selectedStory: UserStoryUIModel?

  // MARK: - INIT

  init(
    viewModel: UserStoriesFullscreenViewModel,
    selectedStory: Binding<UserStoryUIModel?>
  ) {
    _viewModel = StateObject(wrappedValue: viewModel)
    _selectedStory = selectedStory
  }

  // MARK: - VIEWS

  var body: some View {
    GeometryReader { proxy in
      ZStack(alignment: .top) {
        Rectangle()
          .fill(.black)
          .ignoresSafeArea()

        VStack(spacing: .zero) {
          AsyncImage(
            url: viewModel.currentStoryContent?.imageURL,
            content: makeStoryContent,
            placeholder: makeStoryPlaceholder
          )
          .onTapGesture { location in
            if location.x <= proxy.size.width / 2 {
              viewModel.handleLeftSideTap()
            } else {
              viewModel.handleRightSideTap()
            }
          }
        }
        .overlay(alignment: .top) { imageOverlay }
      }
    }
    .onChange(of: viewModel.selectedStory) { selectedStory = viewModel.selectedStory }
    .onChange(of: selectedStory) { viewModel.selectedStory = selectedStory }
  }

  private var imageOverlay: some View {
    VStack(spacing: 8.0) {
      storyProgressIndicator
      HStack(spacing: 8.0) {
        UserAvatarView(url: selectedStory?.profilePictureURL)
          .frame(height: 24.0)
        if let userName = selectedStory?.userName {
          Text(userName)
            .font(.system(size: 14.0, weight: .medium))
            .foregroundStyle(.white)
        }
        Spacer()
        Image(systemName: "xmark")
          .foregroundStyle(.white)
          .contentShape(Rectangle())
          .onTapGesture { selectedStory = nil }
      }
    }
    .padding(8.0)
  }

  private var storyProgressIndicator: some View {
    StoryProgressIndicatorView(
      currentStoryIndex: viewModel.currentStoryContentIndex,
      currentStoryDuration: viewModel.currentStoryContent?.duration ?? 0,
      numberOfStories: viewModel.numberOfStories
    )
    .onAppear(perform: viewModel.handleStoryDurationExpiration)
    .onChange(of: viewModel.currentStoryContent) {
      viewModel.handleStoryDurationExpiration()
    }
    .id(viewModel.selectedStory?.id)
  }

  @ViewBuilder
  private func makeStoryContent(from image: Image) -> some View {
    ZStack(alignment: .top) {
      image
        .resizable()
        .aspectRatio(9 / 16, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
  }

  private func makeStoryPlaceholder() -> some View {
    ZStack {
      Rectangle().fill(.black)
      LoadingSpinnerView()
        .frame(width: 16.0)
    }
  }
}
