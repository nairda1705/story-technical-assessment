import SwiftUI

struct UserAvatarView: View {
  // MARK: - NESTED TYPES

  private enum Constants {
    static let missingAvatarImageName: String = "person.circle.fill"
  }

  // MARK: - PRIVATE PROPERTIES

  private let url: URL?

  // MARK: - INIT

  init(url: URL?) {
    self.url = url
  }

  // MARK: - VIEWS

  var body: some View {
    if let url {
      AsyncImage(
        url: url,
        content: makeAvatarContent,
        placeholder: makeAvatarPlaceholder
      )
    } else {
      missingUserAvatarContent
    }
  }

  private func makeAvatarContent(from image: Image) -> some View {
    image
      .resizable()
      .clipShape(Circle())
      .scaledToFit()
  }

  private func makeAvatarPlaceholder() -> some View {
    Circle().fill(.quaternary)
  }

  private var missingUserAvatarContent: some View {
    Image(systemName: Constants.missingAvatarImageName)
      .resizable()
      .scaledToFit()
      .foregroundStyle(.quaternary)
  }
}
