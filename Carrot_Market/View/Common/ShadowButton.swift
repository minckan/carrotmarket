//
//  ShadowButton.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/03/28.
//

import UIKit


// UIView는 하나의 CALayer(root)만 가지고 있고,
// 이 CALayer(root)는 SubLayer를 여러개 둘수 있다.
// UIView의 SubView는 UIView(root)에 얹혀지는 것.
public final class ShadowButton : UIButton {
    private var shadowLayer: CALayer?
    private var backgroundLayer: CALayer?
    
    public override var isHighlighted: Bool { // CA는 이벤트를 받지 못하기 때문에 UIView의 이벤트를 받아 layer 색상 변경
        didSet {
            guard let layer = backgroundLayer else {return}
            
            layer.backgroundColor = isHighlighted ? UIColor.carrotOrange500.cgColor  : UIColor.carrotOrange400.cgColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        setConfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func draw(_ rect: CGRect) {
        configureLayer(rect)
    }
    
    private func render() {
        setImage(UIImage(named: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        
        tintColor = .white
    }
    
    private func setConfigure() {
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.plain()
        } else {
            adjustsImageWhenHighlighted = false
        }
    }
    
    private func configureLayer(_ rect: CGRect) {
        if shadowLayer == nil {
            let shadowLayer = CALayer()
            shadowLayer.masksToBounds = false
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = rect.height / 2
            shadowLayer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: rect.height/2).cgPath
            layer.insertSublayer(shadowLayer, at: 0) // ⭐️ UIView를 addSubView한게 아닌 layer를 insertSubView 했기 때문에 계층하나에서 그림자까지 생성.
            self.shadowLayer = shadowLayer
        }
        
        if backgroundLayer == nil {
            let backgroundLayer = CALayer()
            backgroundLayer.masksToBounds = true
            backgroundLayer.frame = rect
            backgroundLayer.cornerRadius = rect.height/2
            backgroundLayer.backgroundColor = UIColor.carrotOrange500.cgColor
            layer.insertSublayer(backgroundLayer, at: 1)
            self.backgroundLayer = backgroundLayer
        }
    }
}
