
private let kUDDidShowFirstTimeRoutingEducationalHint = "kUDDidShowFirstTimeRoutingEducationalHint"

class BottomTabBarViewController: UIViewController {
  var presenter: BottomTabBarPresenterProtocol!
  
  @IBOutlet var searchButton: MWMButton!
  @IBOutlet var searchConstraint: NSLayoutConstraint!
  @IBOutlet var leftButton: MWMButton!
  @IBOutlet var leftButtonConstraint: NSLayoutConstraint!
  @IBOutlet var bookmarksButton: MWMButton!
  @IBOutlet var bookmarksConstraint: NSLayoutConstraint!
  @IBOutlet var moreButton: MWMButton!
  @IBOutlet var moreConstraint: NSLayoutConstraint!
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
      self.updateLeftButton()
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    leftButton.imageView?.contentMode = .scaleAspectFit
    updateLeftButton()
    updateBadge()
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
    NSLayoutConstraint.deactivate([leftButtonConstraint, searchConstraint, bookmarksConstraint, moreConstraint])
    
    let leftButtonType = Settings.leftButtonType
    if leftButtonType == .hidden {
      leftButton.isHidden = true
      leftButtonBadge.isHidden = true

      leftButtonConstraint = NSLayoutConstraint(item: leftButtonConstraint.firstItem!, attribute: leftButtonConstraint.firstAttribute, relatedBy: leftButtonConstraint.relation, toItem: leftButtonConstraint.secondItem, attribute: leftButtonConstraint.secondAttribute, multiplier: 0.01, constant: leftButtonConstraint.constant)
      searchConstraint = NSLayoutConstraint(item: searchConstraint.firstItem!, attribute: searchConstraint.firstAttribute, relatedBy: searchConstraint.relation, toItem: searchConstraint.secondItem, attribute: searchConstraint.secondAttribute, multiplier: 0.25, constant: searchConstraint.constant)
      bookmarksConstraint = NSLayoutConstraint(item: bookmarksConstraint.firstItem!, attribute: bookmarksConstraint.firstAttribute, relatedBy: bookmarksConstraint.relation, toItem: bookmarksConstraint.secondItem, attribute: bookmarksConstraint.secondAttribute, multiplier: 1, constant: bookmarksConstraint.constant)
      moreConstraint = NSLayoutConstraint(item: moreConstraint.firstItem!, attribute: moreConstraint.firstAttribute, relatedBy: moreConstraint.relation, toItem: moreConstraint.secondItem, attribute: moreConstraint.secondAttribute, multiplier: 1.75, constant: moreConstraint.constant)
    } else {
      leftButton.isHidden = false
      leftButtonBadge.isHidden = !needsToShowleftButtonBadge()

      leftButton.setTitle(nil, for: .normal)
      leftButton.setImage(leftButtonType.image, for: .normal)
      leftButton.accessibilityLabel = leftButtonType.description;

      leftButtonConstraint = NSLayoutConstraint(item: leftButtonConstraint.firstItem!, attribute: leftButtonConstraint.firstAttribute, relatedBy: leftButtonConstraint.relation, toItem: leftButtonConstraint.secondItem, attribute: leftButtonConstraint.secondAttribute, multiplier: 0.25, constant: leftButtonConstraint.constant)
      searchConstraint = NSLayoutConstraint(item: searchConstraint.firstItem!, attribute: searchConstraint.firstAttribute, relatedBy: searchConstraint.relation, toItem: searchConstraint.secondItem, attribute: searchConstraint.secondAttribute, multiplier: 0.75, constant: searchConstraint.constant)
      bookmarksConstraint = NSLayoutConstraint(item: bookmarksConstraint.firstItem!, attribute: bookmarksConstraint.firstAttribute, relatedBy: bookmarksConstraint.relation, toItem: bookmarksConstraint.secondItem, attribute: bookmarksConstraint.secondAttribute, multiplier: 1.25, constant: bookmarksConstraint.constant)
      moreConstraint = NSLayoutConstraint(item: moreConstraint.firstItem!, attribute: moreConstraint.firstAttribute, relatedBy: moreConstraint.relation, toItem: moreConstraint.secondItem, attribute: moreConstraint.secondAttribute, multiplier: 1.75, constant: moreConstraint.constant)
    }
    NSLayoutConstraint.activate([leftButtonConstraint, searchConstraint, bookmarksConstraint, moreConstraint])
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
