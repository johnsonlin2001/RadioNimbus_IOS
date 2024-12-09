//
//  FavScrollView.swift
//  RadioNimbus
//
//  Created by Johnson Lin on 2024/12/10.
//

import UIKit

class FavScrollView: UIScrollView {
    var subView: UIView?

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            if let subView = subView {
                let convertedPoint = self.convert(point, to: subView)
                if subView.point(inside: convertedPoint, with: event) {
                    return subView
                }
            }
            return super.hitTest(point, with: event)
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
