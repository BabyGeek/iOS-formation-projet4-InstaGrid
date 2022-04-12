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

//MARK: - Extension for ItemSource protocol

/// For sharing purposes
extension SelectedView: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Hey that is my new grid image using the perfect Instagrid app!"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return self.asImage()
    }

    
    /// Convert the view to an image
    /// - Returns: Image of the current SelectedView state
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
