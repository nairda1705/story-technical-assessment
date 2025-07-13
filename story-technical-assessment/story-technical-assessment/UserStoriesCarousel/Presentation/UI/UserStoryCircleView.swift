import SwiftUI

struct UserStoryCircleView: View {
  // MARK: - PRIVATE PROPERTIES

  private let model: UserStoryUIModel

  // MARK: - INIT

  init(model: UserStoryUIModel) {
    self.model = model
  }

  // MARK: - VIEWS

  var body: some View {
    VStack(spacing: 4.0) {
      ZStack {
        Circle()
          .inset(by: 2.0)
          .stroke(.primary, lineWidth: 4.0)
        makeUserAvatar()
      }
      .frame(height: 64.0)
      Text(model.userName)
        .font(.system(size: 12.0, weight: .medium))
        .foregroundStyle(.primary)
        .lineLimit(1)
    }
    .frame(width: 64.0)
  }

  private func makeUserAvatar() -> some View {
    UserAvatarView(url: model.profilePictureURL)
      .padding(6.0)
  }
}
