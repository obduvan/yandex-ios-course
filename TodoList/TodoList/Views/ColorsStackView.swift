//
//  ColorsTodoView.swift
//  TodoList
//
//  Created by Артем Яблоковский on 01.12.2021.
//

import Foundation
import UIKit

protocol ColorsViewDelegate {
    func setChosedColor(color: UIColor)
}

class ColorsStackView: UIStackView {
    
    @IBOutlet weak var firstLine: UIView!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var thirdLine: UIView!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    
    private let firstLineColor = UIColor.white
    private let secondLineColor = UIColor.init(red: 92/255, green: 139/255, blue: 168/255, alpha: 1)
    private let thirdLineColor = UIColor.systemOrange
    
    private let highlightDuration: TimeInterval = 0.25
    
    var delegate: ColorsViewDelegate?
    
    
    func initColorLines(_ color: UIColor){
    switch color {
        case thirdLineColor:
            showLines(line: thirdLine, color: color)
        case secondLineColor:
            showLines(line: secondLine, color: color)
        default:
            showLines(line: firstLine, color: .white)
        }
    }
    
    @IBAction func butFirstClicked(_ sender: UIButton) {
        UIView.animate(withDuration: highlightDuration) {
            self.unHighlight(button: sender)
            self.showLines(line: self.firstLine, color: self.firstLineColor)
        }
    }
    
    @IBAction func butSecondClicked(_ sender: UIButton) {
        UIView.animate(withDuration: highlightDuration) {
            self.unHighlight(button: sender)
            self.showLines(line: self.secondLine, color: self.secondLineColor)
        }
    }
    
    @IBAction func butThirdClicked(_ sender: UIButton) {
        UIView.animate(withDuration: highlightDuration) {
            self.unHighlight(button: sender)
            self.showLines(line: self.thirdLine,color: self.thirdLineColor)
        }
    }
    
     private func showLines(line: UIView, color: UIColor) {
        self.hideLines()
        line.backgroundColor = color
        
        delegate?.setChosedColor(color: color)
    }
    
    private func hideLines(){
        firstLine.backgroundColor = UIColor.clear
        secondLine.backgroundColor = UIColor.clear
        thirdLine.backgroundColor = UIColor.clear
    }
    
    private func unHighlight(button: UIButton) {
        button.backgroundColor = button.backgroundColor?.withAlphaComponent(0.5)
        button.backgroundColor = button.backgroundColor?.withAlphaComponent(1)
    }
}
