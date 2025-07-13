import SwiftUI

struct StoryProgressIndicatorView: View {
  // MARK: - PRIVATE PROPERTIES

  private let currentStoryIndex: Int
  private let currentStoryDuration: Int
  private let numberOfStories: Int

  @State private var startTime: Date = .now
  @State private var timer: Timer?
  @State private var progress: CGFloat = .zero

  // MARK: - INIT

  init(
    currentStoryIndex: Int,
    currentStoryDuration: Int,
    numberOfStories: Int
  ) {
    self.currentStoryIndex = currentStoryIndex
    self.currentStoryDuration = currentStoryDuration
    self.numberOfStories = numberOfStories
  }

  // MARK: - VIEWS

  var body: some View {
    HStack(spacing: 2.0) {
      ForEach(0 ..< numberOfStories, id: \.self) { index in
        let wasViewed = index < currentStoryIndex
        GeometryReader { proxy in
          ZStack(alignment: .leading) {
            if wasViewed {
              Capsule().fill(.white)
            } else {
              Capsule().fill(.tertiary)
            }
            if index == currentStoryIndex {
              Capsule()
                .fill(.white)
                .frame(width: progress * proxy.size.width)
            }
          }
        }
      }
    }
    .frame(height: 2.0)
    .onChange(of: currentStoryIndex, resetTimer)
    .onAppear(perform: resetTimer)
  }

  private func resetTimer() {
    timer?.invalidate()
    startTime = .now
    progress = .zero
    timer = Timer.scheduledTimer(withTimeInterval: 1 / 30, repeats: true) { timer in
      progress = Date().timeIntervalSince(startTime) / Double(currentStoryDuration)
      if progress >= 1.0 {
        timer.invalidate()
      }
    }
  }
}
