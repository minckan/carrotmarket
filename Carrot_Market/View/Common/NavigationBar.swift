//
//  NavigationController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/27.
//

import UIKit

protocol CommonNavigationDelegate : AnyObject {
    var controller : UIViewController { get }
}

class CommonNavigation {
 
    weak var delegate: CommonNavigationDelegate?
    
    var mainColor:UIColor = .darkGray {
        didSet {
            configureUI()
        }
    }
    
    
    
    lazy var searchButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal).withTintColor(mainColor), for: .normal)
        button.addTarget(self, action: #selector(handleSearchButtonTapped), for: .touchUpInside)
        return barItem
    }()

    lazy var menuButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal).withTintColor(mainColor), for: .normal)
        button.addTarget(self, action: #selector(handleMenuhButtonTapped), for: .touchUpInside)
        return barItem
    }()

    lazy var notificationButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "notification")?.withRenderingMode(.alwaysOriginal).withTintColor(mainColor), for: .normal)
        button.addTarget(self, action: #selector(handleNotificationButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    lazy var backButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal).withTintColor(mainColor), for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return barItem
    }()
    
    lazy var profileButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "happy")?.withRenderingMode(.alwaysOriginal).withTintColor(mainColor), for: .normal)
        button.addTarget(self, action: #selector(handleProfileButtonTapped), for: .touchUpInside)
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
        if mainColor == .white {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            delegate?.controller.navigationController?.navigationBar.standardAppearance = appearance
            delegate?.controller.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            delegate?.controller.edgesForExtendedLayout = UIRectEdge.top
        }
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
    
}

