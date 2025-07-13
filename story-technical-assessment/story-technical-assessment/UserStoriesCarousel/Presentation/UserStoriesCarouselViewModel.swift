import Combine
import Foundation

class UserStoriesCarouselViewModel: ObservableObject {
  // MARK: - PUBLIC PROPERTIES

  @Published var model = UserStoriesCarouselUIModel()

  // MARK: - PRIVATE PROPERTIES

  private let repository: UserStoryRepository
  private let mapper = UserStoriesCarouselUIMapper()

  private var fetchingTask: Task<Void, Never>?
  private var subscriptions = Set<AnyCancellable>()
  private var presentationData = UserStoriesCarouselPresentationData()

  // MARK: - INIT

  init(repository: UserStoryRepository) {
    self.repository = repository
  }

  // MARK: - PUBLIC PROPERTIES

  func handleOnAppear() {
    guard presentationData.currentPage == .zero else { return }
    initiateNextPageFetch()
  }

  func handleOnLastStoryAppear() {
    initiateNextPageFetch()
  }

  // MARK: - PRIVATE METHODS

  private func initiateNextPageFetch() {
    let isLastPage = presentationData.pages.last?.isLastPage ?? false
    guard !isLastPage, !model.isFetchingNextPage else { return }
    fetchingTask = Task { [weak self] in await self?.fetchNextPage() }
  }

  @MainActor
  private func fetchNextPage() async {
    model.isFetchingNextPage = true
    presentationData.currentPage += 1
    do {
      let currentPage = try await repository.fetchUserStoriesPage(page: presentationData.currentPage)
      presentationData.pages.append(currentPage)
      model.stories = mapper.mapUserStories(from: presentationData.pages.flatMap { $0.stories })
      model.isFetchingNextPage = false
    } catch {
      // TODO: HANDLE ERROR
    }
  }
}
