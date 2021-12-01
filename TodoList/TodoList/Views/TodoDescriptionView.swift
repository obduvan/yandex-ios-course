//
//  TodoDescriptionView.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit
import Foundation


protocol DescriptionViewDelegate {
    func setDescription(description: String)
}


class TodoDescriptionView: UITextView, UITextViewDelegate {
    
    private let placeholder = "Описание дела"
    private let padding: CGFloat = 10
    private let maxLinesDescription: Int = 20
    private var descriptionTodo: String = ""

    var descriptionDelegate: DescriptionViewDelegate?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        delegate = self
        setupDescription()
    }
    
    private func setupDescription() {
        textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        if text.isEmpty{
            text = placeholder
            textColor = UIColor.lightGray
        }
    }
    
    var numberOfCurrentlyDisplayedLines: Int {
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return Int(((size.height - self.layoutMargins.top - self.layoutMargins.bottom) /
                        self.font!.lineHeight))
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGray
            descriptionTodo = ""
        }
        else{
            descriptionTodo = textView.text

        }
        
        descriptionDelegate?.setDescription(description: descriptionTodo)
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        removeTextUntilSatisfying(maxNumberOfLines: maxLinesDescription)
    }
    
    func removeTextUntilSatisfying(maxNumberOfLines: Int) {
        while numberOfCurrentlyDisplayedLines > maxNumberOfLines {
            self.text = String(self.text.dropLast())
            self.layoutIfNeeded()
        }
    }
}
