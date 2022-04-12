//
//  ViewController.swift
//  InstaGrid
//
//  Created by Paul Oggero on 06/04/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    private var selectedTab: UIButton?
    private var validGesture: Bool = false
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var selectedView: SelectedView!
    @IBOutlet var layoutButtons: [UIButton]!
    
    private var selected: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelectedButton()
        animateRoll()
        
        let panGestureSelectedViewRecognize = UIPanGestureRecognizer(target: self, action: #selector(dragToShare))
        let panGestureSwipeiewRecognize = UIPanGestureRecognizer(target: self, action: #selector(dragToShare))
        selectedView.addGestureRecognizer(panGestureSelectedViewRecognize)
        swipeView.addGestureRecognizer(panGestureSwipeiewRecognize)
    }
    
    
    @objc func dragToShare(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            makeTransitionToShareWith(sender)
            break
        case .ended, .cancelled:
            if self.validGesture {
                showActivityController()
            }
            break
        default:
            break
        }
    }
    
    func updateSelectedButton() {
        for index in layoutButtons.indices {
            if !layoutButtons[index].isSelected {
                layoutButtons[index].setImage(nil, for: .normal)
            } else {
                self.selected = index
                switch layoutButtons[index] {
                case layoutButtons[0]:
                    selectedView.layout = .layout1
                case layoutButtons[1]:
                    selectedView.layout = .layout2
                case layoutButtons[2]:
                    selectedView.layout = .layout3
                default:
                    selectedView.layout = .layout2
                }
            }
        }
    }
    
    @IBAction func layoutSelected(_ sender: UIButton) {
        switch sender {
        case layoutButtons[0]:
            selectedView.layout = .layout1
            selectButton(0)
        case layoutButtons[1]:
            selectedView.layout = .layout2
            selectButton(1)
        case layoutButtons[2]:
            selectedView.layout = .layout3
            selectButton(2)
            
        default:
            selectedView.layout = .layout2
            selectButton(1)
            
        }
        
        
        for index in layoutButtons.indices {
            if !layoutButtons[index].isSelected {
                layoutButtons[index].setImage(nil, for: .normal)
            }
        }
        
        animateRoll()
    }
    
    func selectButton(_ index: Int) {
        self.selected = index
        
        for index in layoutButtons.indices {
            if index == selected {
                layoutButtons[index].isSelected = true
            }else {
                layoutButtons[index].isSelected = false
            }
        }
    }
    
}


extension ViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self.selectedTab?.setImage(image.resizableImage(withCapInsets: .zero, resizingMode: .stretch), for: .normal)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.async {
                self.selectedTab?.setImage(image, for: .normal)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageSelectionTapped(_ sender: UIButton) {
        selectedTab = sender
        
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration(photoLibrary: .shared())
            configuration.selectionLimit = 1
            configuration.filter = .images
            
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
    }
}


extension ViewController {
    
    /// Make the transition in function of the app orientation
    /// - Parameter gesture: gesture made by the user on the selectedView
    func makeTransitionToShareWith(_ gesture: UIPanGestureRecognizer) {
        var x = self.selectedView.frame.minX
        var y = self.selectedView.frame.minY
        
        if UIApplication.shared.statusBarOrientation.isLandscape {
            if gesture.velocity(in: self.selectedView).x < 0 {
                self.validGesture = true
                
                let translation = gesture.translation(in: self.selectedView)
                x = translation.x
            } else {
                self.validGesture = false
            }
            
        } else {
            if gesture.velocity(in: self.selectedView).y < 0 {
                self.validGesture = true
                
                let translation = gesture.translation(in: self.selectedView)
                y = translation.y
                
            } else {
                self.validGesture = false
            }
        }
        
        if self.validGesture {
            let transform = CGAffineTransform(translationX: x, y: y)
            self.selectedView.transform = transform
        }
    }
    
    
    /// show the UIActivityController if the user as a correct gesture ended or stopped and reset the gesture validation
    func showActivityController() {
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        
        var tanslationTransform: CGAffineTransform

        if UIApplication.shared.statusBarOrientation.isLandscape {
            tanslationTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
        } else {
            tanslationTransform = CGAffineTransform(translationX: selectedView.frame.minX, y: -screenHeight)
        }
        
        let items: [Any] = [selectedView.self as Any]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
        
        UIView.animate(withDuration: 0.8, animations: { self.selectedView.transform = tanslationTransform }, completion: nil)
        
        ac.completionWithItemsHandler = { (activityType, completed: Bool,
            returnedItems: [Any]?, error: Error?) in
            if completed {
                UIView.animate(withDuration: 1) {
                    self.selectedView.transform = .identity
                }
           }
        }
    }
    
    
    /// Reset the position of selectedView with animation zoom in
    func displaySelectedViewWithAnimation() {
        selectedView.transform = .identity
        selectedView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.selectedView.transform = .identity
        }, completion: nil)
    }
    
    
    /// Make roll animation to selectedView
    func animateRoll() {
        selectedView.transform = CGAffineTransform(scaleX: -0.01, y: -0.01)
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.selectedView.transform = .identity
        }, completion: nil)
    }
}

