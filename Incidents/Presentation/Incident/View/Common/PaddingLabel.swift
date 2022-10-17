//
//  PaddingLabel.swift
//  Incidents
//
//  Created by bindu.ojha on 14/10/22.
//

import Foundation
import UIKit

// MARK: A class to provide padding for data inside label.
final class PaddingLabel: UILabel {
    
    var topInset: CGFloat
    var bottomInset: CGFloat
    var leftInset: CGFloat
    var rightInset: CGFloat
    
    init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat){
        self.topInset = top
        self.bottomInset = bottom
        self.rightInset = right
        self.leftInset = left
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    
    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}
