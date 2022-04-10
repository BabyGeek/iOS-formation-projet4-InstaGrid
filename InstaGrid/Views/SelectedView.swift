//
//  SelectedView.swift
//  InstaGrid
//
//  Created by Paul Oggero on 10/04/2022.
//

import UIKit

class SelectedView: UIView {
    @IBOutlet var leftTopButton: UIButton!
    @IBOutlet var rightTopButton: UIButton!
    @IBOutlet var leftBottomButton: UIButton!
    @IBOutlet var rightBottomButton: UIButton!
    
    
    enum Layout {
        case layout1, layout2, layout3
    }
    
    var layout: Layout = .layout2 {
        didSet {
            setLayout(layout)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setLayout(_ layout: Layout) {
        switch layout {
        case .layout1:
            setLayout1()
        case .layout2:
            setLayout2()
        case .layout3:
            setLayout3()
        }
    }
    
    func setLayout1() {
        rightTopButton.isHidden = true
        leftTopButton.isHidden = false
        leftBottomButton.isHidden = false
        rightBottomButton.isHidden = false
    }
    
    func setLayout2() {
        rightBottomButton.isHidden = true
        leftBottomButton.isHidden = false
        leftTopButton.isHidden = false
        rightTopButton.isHidden = false
    }
    
    func setLayout3() {
        rightBottomButton.isHidden = false
        leftBottomButton.isHidden = false
        leftTopButton.isHidden = false
        rightTopButton.isHidden = false
    }
}
