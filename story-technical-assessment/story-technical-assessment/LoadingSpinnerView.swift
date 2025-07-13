import SwiftUI

struct LoadingSpinnerView: View {
  // MARK: - NESTED TYPES

  private enum Constants {
    static let animationDuration: Double = 1.0
    static var halfAnimationDuration: Double { animationDuration * 0.5 }
    static let lineWidth: CGFloat = 2.0
    static let minusNinetyDegrees: Angle = .degrees(-90.0)
    static let fullTrim: CGFloat = 1.0
  }

  // MARK: - PRIVATE PROPERTIES

  @State private var startTrim: CGFloat = .zero
  @State private var endTrim: CGFloat = .zero

  // MARK: - VIEWS

  var body: some View {
    ZStack {
      backgroundCircle
      foregroundCircle
    }
    .onAppear(perform: startAnimating)
  }

  private var backgroundCircle: some View {
    Circle()
      .stroke(
        .tertiary,
        style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round)
      )
  }

  private var foregroundCircle: some View {
    Circle()
      .trim(from: startTrim, to: endTrim)
      .stroke(
        .primary,
        style: StrokeStyle(lineWidth: Constants.lineWidth, lineCap: .round)
      )
      .rotationEffect(Constants.minusNinetyDegrees)
  }

  // MARK: - PRIVATE METHODS

  func startAnimating() {
    withAnimation(.easeIn(duration: Constants.halfAnimationDuration)) {
      endTrim = Constants.fullTrim
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.halfAnimationDuration) {
      withAnimation(.easeOut(duration: Constants.halfAnimationDuration)) {
        startTrim = Constants.fullTrim
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + Constants.animationDuration) {
      startTrim = .zero
      endTrim = .zero
      startAnimating()
    }
  }
}
