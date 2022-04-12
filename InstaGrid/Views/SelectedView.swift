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
    
    
    /// Layouts enumerator
    enum Layout {
        case layout1, layout2, layout3
    }
    
    
    /// The current layout with automatic change when value updated
    var layout: Layout = .layout2 {
        didSet {
            setLayout(layout)
        }
    }
    
    
    /// Change the displayed layout
    /// - Parameter layout: current layout to use
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
    
    
    /// Set the configuration for first Layout
    func setLayout1() {
        rightTopButton.isHidden = true
        leftTopButton.isHidden = false
        leftBottomButton.isHidden = false
        rightBottomButton.isHidden = false
    }
    
    /// Set the configuration for second Layout
    func setLayout2() {
        rightBottomButton.isHidden = true
        leftBottomButton.isHidden = false
        leftTopButton.isHidden = false
        rightTopButton.isHidden = false
    }
    
    /// Set the configuration for third Layout
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
    
    /// UIActivityItemSource function for placeholder
    /// - Parameter activityViewController: the current UIActivityViewController to be used in
    /// - Returns: the placeholder to use
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Hey that is my new grid image using the perfect Instagrid app!"
    }
    
    
    /// Set the object to return to the UIActivityViewController for precise activityType or not
    /// - Parameters:
    ///   - activityViewController: the current UIActivityViewController to be used in
    ///   - activityType: the activity type
    /// - Returns: the object to return to the UIActivityViewController for the given activityType
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
