//
//  NavigationController.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/27.
//

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

class CommonNavigation {
 
    weak var delegate: CommonNavigationDelegate?
    
    var type: UIType = .black {
        didSet {
            print("DEBUG: I WAS CALLED!!!!!!!")
            configureUI()
        }
    }
    
    
    
    lazy var searchButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "search")?.withRenderingMode(.alwaysOriginal).withTintColor(type.primaryColor), for: .normal)
        button.addTarget(self, action: #selector(handleSearchButtonTapped), for: .touchUpInside)
        return barItem
    }()

    lazy var menuButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal).withTintColor(type.primaryColor), for: .normal)
        button.addTarget(self, action: #selector(handleMenuhButtonTapped), for: .touchUpInside)
        return barItem
    }()

    lazy var notificationButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "notification")?.withRenderingMode(.alwaysOriginal).withTintColor(type.primaryColor), for: .normal)
        button.addTarget(self, action: #selector(handleNotificationButtonTapped), for: .touchUpInside)
        return barItem
    }()
    
    lazy var backButton : UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "back")?.withRenderingMode(.alwaysOriginal).withTintColor(type.primaryColor), for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return barItem
    }()
    
    lazy var profileButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        let barItem = UIBarButtonItem(customView: button)
        button.setImage(UIImage(named: "happy")?.withRenderingMode(.alwaysOriginal).withTintColor(type.primaryColor), for: .normal)
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

        case .black:
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground() // 배경을 불투명하게 설정
            appearance.backgroundColor = .white // 배경 색상을 화이트로 설정
            
            delegate?.controller.navigationController?.navigationBar.tintColor = .label


            delegate?.controller.navigationController?.navigationBar.standardAppearance = appearance
            delegate?.controller.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            delegate?.controller.navigationController?.navigationBar.compactAppearance = appearance
            
        }
        delegate?.controller.navigationController?.setNeedsStatusBarAppearanceUpdate()
       
    }
    
}

