//
//  MainTabContoller.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/21.
//

import UIKit
import FirebaseAuth

class MainTabController : UITabBarController{
    // MARK: - Properties
    var userPosition: Position?
    
    let actionButton: ShadowButton = {
        let button = ShadowButton(type: .system)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserService.shared.logUserOut {
//            print("DEBUG: user logged out.")
//        }
        authenticateUserAndConfigureUI()
    }
    
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        let controller = UploadController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    // MARK: - API
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
                DispatchQueue.main.async {
                    let nav = UINavigationController(rootViewController: LoginController())
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true)
                }
            } else {
                configureUI()
                configureTabBarUI()
            }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        
    
    }
    
    func configureTabBarUI() {
        delegate = self

        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        
//        let product = ProductController(collectionViewLayout: layout)
        let product = ProductController(collectionViewLayout: layout)
        
        let nav1 = templateNavigationController(image: UIImage(named: "home"), title: "홈", rootViewController: product)
        
        let community = CommunityController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav2 = templateNavigationController(image: UIImage(named: "group"), title: "동네생활", rootViewController: community)
        
        let chat = ChatController()
        let nav3 = templateNavigationController(image: UIImage(named: "chat"), title: "채팅", rootViewController: chat)
        
        let live = LiveController()
        let nav4 = templateNavigationController(image: UIImage(named: "video"), title: "라이브", rootViewController: live)
        
        let mypage = MyPageController()
        let nav5 = templateNavigationController(image: UIImage(named: "user"), title: "나의 당근", rootViewController: mypage)
        
        viewControllers = [nav1, nav2, nav3, nav4, nav5]
  
        UITabBar.appearance().tintColor = UIColor.carrotOrange500
     
    }
    
    func templateNavigationController(image: UIImage?,title: String,  rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.tabBarItem.title = title
       
        setNavigationBarColor(.white)
        return nav
    }
    
}

extension MainTabController: UITabBarControllerDelegate {

    /*
     Called to allow the delegate to return a UIViewControllerAnimatedTransitioning delegate object for use during a noninteractive tab bar view controller transition.
     ref: https://developer.apple.com/documentation/uikit/uitabbarcontrollerdelegate/1621167-tabbarcontroller
     */
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarAnimatedTransitioning()
    }

}

final class TabBarAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        // toView 먼저 containerView에 추가하고 alpha 값 조절
        toView.alpha = 0.0
        containerView.addSubview(toView)
        
        // fade-in 효과
        UIView.animate(withDuration: duration / 2, animations: {
            toView.alpha = 1.0
        }) { _ in
            // fade-in 완료 후 fade-out 효과 적용
            UIView.animate(withDuration: self.duration / 2, animations: {
                fromView.alpha = 0.0
            }, completion: { _ in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
        }
    }
}

