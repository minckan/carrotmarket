//
//  HorizontalLine.swift
//  Carrot_Market
//
//  Created by MZ01-MINCKAN on 2023/05/26.
//

import UIKit

struct HorizontalLine  {
    // MARK: - Properties
    private let line = UIView()
    private let color: UIColor
    private let size: CGSize
    private let paddingTop : CGFloat
    private let positioningPoint: UIView
    
    // MARK: - Lifecycles
    init(at point: UIView, withColor color: UIColor, size: CGSize, paddingTop: CGFloat) {
        self.color = color
        self.size = size
        self.paddingTop = paddingTop
        self.positioningPoint = point
    }
    
    // MARK: - Helpers
    func createLine() -> UIView {
        line.frame.size = self.size
        line.backgroundColor = self.color
        
        line.snp.makeConstraints { make in
            make.height.equalTo(self.size.height)
            make.left.right.equalTo(positioningPoint)
            make.bottom.equalTo(positioningPoint).inset(50)
        }
        
        return line
    }
}
