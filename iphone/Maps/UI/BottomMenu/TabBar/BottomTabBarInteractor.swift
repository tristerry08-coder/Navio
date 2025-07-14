protocol BottomTabBarInteractorProtocol: AnyObject {
  func openSearch()
  func openLeftButton()
  func openFaq()
  func openBookmarks()
  func openMenu()
}

class BottomTabBarInteractor {
  weak var presenter: BottomTabBarPresenterProtocol?
  private weak var viewController: UIViewController?
  private weak var mapViewController: MapViewController?
  private weak var controlsManager: MWMMapViewControlsManager?
  private let searchManager: SearchOnMapManager

  init(viewController: UIViewController, mapViewController: MapViewController, controlsManager: MWMMapViewControlsManager) {
    self.viewController = viewController
    self.mapViewController = mapViewController
    self.controlsManager = controlsManager
    self.searchManager = mapViewController.searchManager
  }
}

extension BottomTabBarInteractor: BottomTabBarInteractorProtocol {
  func openSearch() {
    searchManager.isSearching ? searchManager.close() : searchManager.startSearching(isRouting: false)
  }
  
  func openLeftButton() {
    switch Settings.leftButtonType {
      case .addPlace:
        if let delegate = controlsManager as? BottomMenuDelegate {
          delegate.addPlace()
        }
      case .settings:
        mapViewController?.openSettings()
      case .recordTrack:
        let mapViewController = MapViewController.shared()!
        let trackRecorder: TrackRecordingManager = .shared
        switch trackRecorder.recordingState {
        case .active:
          mapViewController.showTrackRecordingPlacePage()
        case .inactive:
          trackRecorder.start { result in
            switch result {
            case .success:
              mapViewController.showTrackRecordingPlacePage()
            case .failure:
              break
            }
          }
        }
      default:
        mapViewController?.openAbout()
    }
  }
  
  func openFaq() {
      mapViewController?.openAbout()
  }
  
  func openBookmarks() {
    mapViewController?.bookmarksCoordinator.open()
  }
  
  func openMenu() {
    guard let state = controlsManager?.menuState else {
      fatalError("ERROR: Failed to retrieve the current MapViewControlsManager's state.")
    }
    switch state {
    case .inactive: controlsManager?.menuState = .active
    case .active: controlsManager?.menuState = .inactive
    case .hidden:
      // When the current controls manager's state is hidden, accidental taps on the menu button during the hiding animation should be skipped.
      break;
    case .layers: fallthrough
    @unknown default: fatalError("ERROR: Unexpected MapViewControlsManager's state: \(state)")
    }
  }
}
