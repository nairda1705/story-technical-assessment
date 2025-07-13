protocol MutableByCopy {
  func copy(mutator: (inout Self) -> Void) -> Self
}

extension MutableByCopy {
  func copy(mutator: (inout Self) -> Void) -> Self {
    var copy = self
    mutator(&copy)
    return copy
  }
}
