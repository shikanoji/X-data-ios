//
//  NeuMorphismView.swift
//  XData
//
//  Created by Nguyễn Đình Thạch on 06/07/2021.
//

import UIKit

@IBDesignable
class NeuMorphismView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    let darkShadow = CALayer()
    let lightShadow = CALayer()
    
    @IBInspectable var innerShadow: Bool = false {
        didSet {
            if innerShadow {
                setupSelectedState()
            } else {
                setupNormalState()
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 5 {
            didSet {
                self.layer.cornerRadius = cornerRadius
                self.darkShadow.cornerRadius = cornerRadius
                self.lightShadow.cornerRadius = cornerRadius
            }
        }
    
    @IBInspectable var shadowRadius: CGFloat = 5 {
            didSet {
                self.darkShadow.shadowRadius = shadowRadius
                self.lightShadow.shadowRadius = shadowRadius
            }
        }
    
    @IBInspectable var lightShadowHidden: Bool = false {
        didSet {
            if lightShadowHidden {
                self.lightShadow.isHidden = true
            } else {
                self.lightShadow.isHidden = false
            }
        }
    }
    
    @IBInspectable var darkShadowHidden: Bool = false {
        didSet {
            if darkShadowHidden {
                self.darkShadow.isHidden = true
            } else {
                self.darkShadow.isHidden = false
            }
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        if self.innerShadow {
            setupSelectedState()
        } else {
            setupNormalState()
        }
        self.layer.insertSublayer(darkShadow, at: 0)
        self.layer.insertSublayer(lightShadow, at: 0)
    }
    
    func setupNormalState() {
        darkShadow.frame = bounds
        darkShadow.backgroundColor = backgroundColor?.cgColor
        darkShadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        darkShadow.cornerRadius = cornerRadius
        darkShadow.shadowOffset = CGSize(width: shadowRadius, height: shadowRadius)
        darkShadow.shadowOpacity = 1
        darkShadow.shadowRadius = shadowRadius
        
        lightShadow.frame = bounds
        lightShadow.backgroundColor = backgroundColor?.cgColor
        lightShadow.shadowColor = UIColor.white.cgColor
        lightShadow.cornerRadius = cornerRadius
        lightShadow.shadowOffset = CGSize(width: -shadowRadius, height: -shadowRadius)
        lightShadow.shadowOpacity = 1
        lightShadow.shadowRadius = shadowRadius
    }
    
    func setupSelectedState() {
        
    }
}
