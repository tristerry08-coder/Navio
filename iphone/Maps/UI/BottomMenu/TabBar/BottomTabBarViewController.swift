
private let kUDDidShowFirstTimeRoutingEducationalHint = "kUDDidShowFirstTimeRoutingEducationalHint"

class BottomTabBarViewController: UIViewController {
  var presenter: BottomTabBarPresenterProtocol!
  
  @IBOutlet var searchButton: MWMButton!
  @IBOutlet var searchConstraintWithLeftButton: NSLayoutConstraint!
  @IBOutlet var searchConstraintWithoutLeftButton: NSLayoutConstraint!
  @IBOutlet var leftButton: MWMButton!
  @IBOutlet var bookmarksButton: MWMButton!
  @IBOutlet var bookmarksConstraintWithLeftButton: NSLayoutConstraint!
  @IBOutlet var bookmarksConstraintWithoutLeftButton: NSLayoutConstraint!
  @IBOutlet var moreButton: MWMButton!
  @IBOutlet var downloadBadge: UIView!
  @IBOutlet var leftButtonBadge: UIView!
  
  private var avaliableArea = CGRect.zero
  @objc var isHidden: Bool = false {
    didSet {
      updateFrame(animated: true)
    }
  }
  @objc var isApplicationBadgeHidden: Bool = true {
    didSet {
      updateBadge()
    }
  }
  var tabBarView: BottomTabBarView {
    return view as! BottomTabBarView
  }
  @objc static var controller: BottomTabBarViewController? {
    return MWMMapViewControlsManager.manager()?.tabBarController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.configure()
    
    NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { _ in
      DispatchQueue.main.async {
        self.updateLeftButton()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    leftButton.imageView?.contentMode = .scaleAspectFit
    updateBadge()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    updateLeftButton()
  }
  
  static func updateAvailableArea(_ frame: CGRect) {
    BottomTabBarViewController.controller?.updateAvailableArea(frame)
  }
  
  @IBAction func onSearchButtonPressed(_ sender: Any) {
    presenter.onSearchButtonPressed()
  }
  
  @IBAction func onLeftButtonPressed(_ sender: Any) {
    if !leftButtonBadge.isHidden {
      presenter.onLeftButtonPressed(withBadge: true)
      setLeftButtonBadgeShown()
    } else {
      presenter.onLeftButtonPressed(withBadge: false)
    }
  }
  
  @IBAction func onBookmarksButtonPressed(_ sender: Any) {
    presenter.onBookmarksButtonPressed()
  }
  
  @IBAction func onMenuButtonPressed(_ sender: Any) {
    presenter.onMenuButtonPressed()
  }
  
  private func updateAvailableArea(_ frame:CGRect) {
    avaliableArea = frame
    updateFrame(animated: false)
    self.view.layoutIfNeeded()
  }
  
  private func updateFrame(animated: Bool) {
    if avaliableArea == .zero {
      return
    }
    let newFrame = CGRect(x: avaliableArea.minX,
                          y: isHidden ? avaliableArea.minY + avaliableArea.height : avaliableArea.minY,
                          width: avaliableArea.width,
                          height: avaliableArea.height)
    let alpha:CGFloat = isHidden ? 0 : 1
    if animated {
      UIView.animate(withDuration: kDefaultAnimationDuration,
                     delay: 0,
                     options: [.beginFromCurrentState],
                     animations: {
        self.view.frame = newFrame
        self.view.alpha = alpha
      }, completion: nil)
    } else {
      self.view.frame = newFrame
      self.view.alpha = alpha
    }
  }
  
  private func updateLeftButton() {
    let leftButtonType = Settings.leftButtonType
    if leftButtonType == .hidden {
      leftButton.isHidden = true
      leftButtonBadge.isHidden = true

      if let searchConstraintWithLeftButton, let searchConstraintWithoutLeftButton, let bookmarksConstraintWithLeftButton, let bookmarksConstraintWithoutLeftButton {
        NSLayoutConstraint.deactivate([searchConstraintWithLeftButton, bookmarksConstraintWithLeftButton])
        NSLayoutConstraint.activate([searchConstraintWithoutLeftButton, bookmarksConstraintWithoutLeftButton])
      }
    } else {
      leftButton.isHidden = false
      leftButtonBadge.isHidden = !needsToShowleftButtonBadge()

      leftButton.setTitle(nil, for: .normal)
      leftButton.setImage(leftButtonType.image, for: .normal)
      leftButton.accessibilityLabel = leftButtonType.description;

      if let searchConstraintWithLeftButton, let searchConstraintWithoutLeftButton, let bookmarksConstraintWithLeftButton, let bookmarksConstraintWithoutLeftButton {
        NSLayoutConstraint.deactivate([searchConstraintWithoutLeftButton, bookmarksConstraintWithoutLeftButton])
        NSLayoutConstraint.activate([searchConstraintWithLeftButton, bookmarksConstraintWithLeftButton])
      }
    }
  }
  
  private func updateBadge() {
    downloadBadge.isHidden = isApplicationBadgeHidden
    leftButtonBadge.isHidden = !needsToShowleftButtonBadge() || Settings.leftButtonType == .hidden
  }
}

// MARK: - Help badge
private extension BottomTabBarViewController {
  private func needsToShowleftButtonBadge() -> Bool {
    !UserDefaults.standard.bool(forKey: kUDDidShowFirstTimeRoutingEducationalHint)
  }
  
  private func setLeftButtonBadgeShown() {
    UserDefaults.standard.set(true, forKey: kUDDidShowFirstTimeRoutingEducationalHint)
  }
}
