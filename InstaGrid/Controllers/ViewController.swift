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
    
    @IBOutlet weak var selectedView: SelectedView!
    @IBOutlet var layoutButtons: [UIButton]!
    
    private var selected: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSelectedButton()
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
                    self.selectedTab?.setImage(image, for: .normal)
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

