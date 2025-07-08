protocol BottomTabBarPresenterProtocol: AnyObject {
  func configure()
  func onSearchButtonPressed()
  func onLeftButtonPressed(withBadge: Bool)
  func onBookmarksButtonPressed()
  func onMenuButtonPressed()
}

class BottomTabBarPresenter: NSObject {
  private let interactor: BottomTabBarInteractorProtocol
  
  init(interactor: BottomTabBarInteractorProtocol) {
    self.interactor = interactor
  }
}

extension BottomTabBarPresenter: BottomTabBarPresenterProtocol {
  func configure() {
  }

  func onSearchButtonPressed() {
    interactor.openSearch()
  }

  func onLeftButtonPressed(withBadge: Bool) {
    withBadge ? interactor.openFaq() : interactor.openLeftButton()
  }

  func onBookmarksButtonPressed() {
    interactor.openBookmarks()
  }

  func onMenuButtonPressed() {
    interactor.openMenu()
  }
}

