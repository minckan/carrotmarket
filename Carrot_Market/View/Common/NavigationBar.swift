//
//  NavigationController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/27.
//


// Navigation Style 관련 코드
import UIKit

enum UIType {
    case white
    case black
    
    var primaryColor : UIColor {
        switch self {
        case .white: return UIColor.white
        case .black: return UIColor.darkGray
        }
    }
}

protocol CommonNavigationDelegate : AnyObject {
    var controller : UIViewController { get }
}

protocol CommonNavigationButtonHandlerDelegate: AnyObject {
    func handleActionSheet()
    func handleShareButton()
}

class CommonNavigation {
 
    weak var delegate: CommonNavigationDelegate? {
        didSet {
            configureUI()
        }
    }
    
    weak var buttonHandelerDelegate : CommonNavigationButtonHandlerDelegate?
    
    var type: UIType = .black {
        didSet {
            configureUI()
        }
    }
    
    var isDarkContentBackground = false

    lazy var searchButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "search"), for: .normal)
        button.addTarget(self, action: #selector(handleSearchButtonTapped), for: .touchUpInside)

        return barItem
    }()

    lazy var menuButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "menu"), for: .normal)

        button.addTarget(self, action: #selector(handleMenuhButtonTapped), for: .touchUpInside)
        return barItem
    }()

    lazy var notificationButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "notification"), for: .normal)

        button.addTarget(self, action: #selector(handleNotificationButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    lazy var backButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "back"), for: .normal)

        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return barItem
    }()
    
    lazy var profileButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "happy"), for: .normal)

        button.addTarget(self, action: #selector(handleProfileButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    lazy var homeButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "home"), for: .normal)

        button.addTarget(self, action: #selector(handleHomeButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    
    lazy var uploadButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "icon_upload"), for: .normal)

        button.addTarget(self, action: #selector(handleUploadButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    lazy var actionSheetButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "vertical_dots"), for: .normal)

        button.addTarget(self, action: #selector(handleActionSheetButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    
    
    
    //MARK: - Lifecycle
    // MARK: - Selectors
    @objc func handleSearchButtonTapped() {
        navigate(modalTo: SearchController())
    }

    @objc func handleMenuhButtonTapped() {
        navigate(pushTo: CategoryController())
    }

    @objc func handleNotificationButtonTapped() {
        navigate(pushTo: NotificationController())
    }
    
    @objc func handleProfileButtonTapped() {
        navigate(modalTo: SearchController())
    }
    
    @objc func handleHomeButtonTapped() {
        // navigation controller depth가 있을 경우 rootview로 이동하기 위한 로직.
        if let presentingVC = self.delegate?.controller.presentingViewController as? UINavigationController {
            self.delegate?.controller.dismiss(animated: true) {
                presentingVC.popToRootViewController(animated: true)
            }
        }
        else {
            self.delegate?.controller.dismiss(animated: true)
        }
    }
    
    @objc func handleUploadButtonTapped() {
        self.buttonHandelerDelegate?.handleShareButton()
    }
    
    @objc func handleActionSheetButtonTapped() {
        buttonHandelerDelegate?.handleActionSheet()
    }
    
    @objc func handleDismissal() {
        guard let viewController = delegate?.controller else {return}
        
        if let presentingViewController = viewController.presentingViewController {
            // 현재 뷰 컨트롤러가 모달 방식으로 표시되었음
            presentingViewController.dismiss(animated: true, completion: nil)
        } else if let navigationController = viewController.navigationController {
            // 현재 뷰 컨트롤러가 네비게이션 스택에 추가되었음
            navigationController.popViewController(animated: true)
        }
    }
    
    // MARK: Helpers
    func configureUI() {
        updateNavigationUI(to: type)
    }
    func navigate(modalTo VC: UIViewController) {
        guard let viewController = delegate?.controller else {return}

        let controller = VC
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true, completion: nil)
    }
    
    func navigate(pushTo VC: UIViewController) {
        guard let viewController = delegate?.controller else {return}

        let controller = VC
        let navigationController = UINavigationController(rootViewController: controller)
        
        viewController.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func updateNavigationUI(to type: UIType) {
        switch type {
        case .white:
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            delegate?.controller.navigationController?.navigationBar.standardAppearance = appearance
            delegate?.controller.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            delegate?.controller.edgesForExtendedLayout = UIRectEdge.top
            delegate?.controller.navigationController?.navigationBar.tintColor = .white
            delegate?.controller.navigationItem.scrollEdgeAppearance = appearance
            delegate?.controller.navigationItem.standardAppearance = appearance
            delegate?.controller.navigationItem.compactAppearance = appearance
            statusBarEnterDarkBackground()
            
        case .black:
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // 배경을 불투명하게 설정
            appearance.backgroundColor = .white // 배경 색상을 화이트로 설정
            delegate?.controller.navigationController?.navigationBar.tintColor = .black
            delegate?.controller.navigationItem.standardAppearance = appearance
            delegate?.controller.navigationItem.scrollEdgeAppearance = appearance
            delegate?.controller.navigationItem.compactAppearance = appearance
            statusBarEnterLightBackground()
            
        }
    
       
    }
    
    func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        UIView.animate(withDuration: 0.3) {
            self.delegate?.controller.setNeedsStatusBarAppearanceUpdate()
        }
        
    }

    func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        UIView.animate(withDuration: 0.3) {
            self.delegate?.controller.setNeedsStatusBarAppearanceUpdate()
        }
    }

}

// view controller 가 네비게이션 안에 있을때는 단순히 preferredStatusBarStyle를 오버라이드 하는 것으로 status bar style이 변경되지 않음
open class DynamicStatusBarNavigation: UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
