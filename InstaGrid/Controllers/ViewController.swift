//
//  ViewController.swift
//  InstaGrid
//
//  Created by Paul Oggero on 06/04/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var selectedView: SelectedView!
    @IBOutlet var layoutButtons: [UIButton]!
    
    private var selected: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    
    func update() {
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

