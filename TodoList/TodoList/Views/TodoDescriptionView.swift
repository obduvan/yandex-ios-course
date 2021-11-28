//
//  TodoDescriptionView.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit
import Foundation

class TodoDescriptionView: UITextView, UITextViewDelegate {
    
    let placeholder = "Описание дела"
    let padding: CGFloat = 10
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDescription()
    }
    
    private func setupDescription() {
        textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        if text.isEmpty{
            text = placeholder
            textColor = UIColor.lightGray
        }
    }
}
