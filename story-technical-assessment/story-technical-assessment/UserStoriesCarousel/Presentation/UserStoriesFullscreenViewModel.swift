import Combine
import Foundation

final class UserStoriesFullscreenViewModel: ObservableObject {
  // MARK: - PUBLIC PROPERTIES

  @Published var selectedStory: UserStoryUIModel?
  @Published var currentStoryContentIndex: Int = .zero

  var currentStoryContent: UserStoryUIModel.Content? {
    guard
      let selectedStory,
      selectedStory.content.indices.contains(currentStoryContentIndex)
    else { return nil }
    return selectedStory.content[currentStoryContentIndex]
  }

  var numberOfStories: Int { selectedStory?.content.count ?? .zero }

  // MARK: - PRIVATE PROPERTIES

  private let repository: UserStoryRepository
  private let models: [UserStoryUIModel]

  private var workItem: DispatchWorkItem?

  // MARK: - INIT

  init(
    repository: UserStoryRepository,
    models: [UserStoryUIModel],
    selectedStory: UserStoryUIModel?
  ) {
    self.repository = repository
    self.models = models
    self.selectedStory = selectedStory
  }

  // MARK: - PUBLIC METHODS

  func handleStoryDurationExpiration() {
    let duration = currentStoryContent?.duration ?? 0
    workItem?.cancel()

    let item = DispatchWorkItem { [weak self] in
      self?.handleRightSideTap()
    }

    workItem = item
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration), execute: item)
  }

  func handleLeftSideTap() {
    let newIndex = currentStoryContentIndex - 1
    if newIndex < 0 {
      goToPreviousStory()
    } else {
      currentStoryContentIndex = newIndex
    }
  }

  func handleRightSideTap() {
    let newIndex = currentStoryContentIndex + 1
    if newIndex >= (selectedStory?.content.count ?? 0) {
      goToNextStory()
    } else {
      currentStoryContentIndex = newIndex
    }
  }

  // MARK: - PRIVATE METHODS

  private func goToPreviousStory() {
    guard
      let current = selectedStory,
      let index = models.firstIndex(of: current)
    else { return }

    let prevIndex = index - 1
    if prevIndex < 0 {
      selectedStory = nil
    } else {
      selectedStory = models[prevIndex]
      currentStoryContentIndex = models[prevIndex].content.count - 1
    }
  }

  private func goToNextStory() {
    guard
      let current = selectedStory,
      let index = models.firstIndex(of: current)
    else { return }

    let nextIndex = index + 1
    if nextIndex >= models.count {
      selectedStory = nil
    } else {
      selectedStory = models[nextIndex]
      currentStoryContentIndex = 0
    }
  }
}
