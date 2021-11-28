//
//  TodoViewController.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit

class TodoViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var datePicket: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var todoDescription: UITextView!
    
    let placeholderDescription = "Описание дела"
    let maxLinesDescription: Int = 20
    
    var keyboardHeight: CGFloat = 0
    var lineCursor: CGFloat = 0
    var lineHeightDiscritpion: CGFloat = 0
    let standartHeightLine: CGFloat = 16.7
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setObervers()
        setKeyboardDismiss()
     
        datePicket.backgroundColor = .white
    }
    
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var dateDivider: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func dateClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            
            if self.datePickerView.isHidden {
                self.datePickerView.isHidden = false
                self.setDateLabel(dateString: self.dateLabel.text ?? "")
            }
            else {
                self.datePickerView.isHidden = true
                self.dateLabelChanged(close: true)
            }
        })
        dateDivider.isHidden = !dateDivider.isHidden
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM YYYY"
        let dateString = dateFormatter.string(from: sender.date)
        
        setDateLabel(dateString: dateString)
        
    }
    
    private func dateLabelChanged(close : Bool) {
        if close {
            self.dateLabel.isHidden = true
        }
        else {
            self.dateLabel.isHidden = false
        }
    }
    
    private func setDateLabel(dateString: String) {
        guard !dateString.isEmpty else { return }
        
        dateLabelChanged(close: false)
        dateLabel.text = dateString
    }
    
    
    private func setKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    @IBAction func buttonCloseClocked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}




extension TodoViewController {
    
    //MARK:- UITextView Description Delegates
    
    public func setObervers() {
        NotificationCenter.default.addObserver(self, selector: #selector(TodoViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TodoViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        todoDescription.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.lineHeightDiscritpion = todoDescription.font?.lineHeight ?? standartHeightLine
        
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    var numberOfCurrentlyDisplayedLines: Int {
        let size = todoDescription.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        return Int(((size.height - todoDescription.layoutMargins.top - todoDescription.layoutMargins.bottom) /
                        todoDescription.font!.lineHeight))
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderDescription
            textView.textColor = .lightGray
        }
        
        textView.resignFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        removeTextUntilSatisfying(maxNumberOfLines: maxLinesDescription)
        
        changeScrollContentOffset()
    }
    
    func changeScrollContentOffset(){
        
        guard let cursorPosition = todoDescription.selectedTextRange?.start else { return }
        
        var newlineCursor = todoDescription.caretRect(for: cursorPosition).origin.y
        if newlineCursor.isInfinite {
            newlineCursor = lineCursor + lineHeightDiscritpion
        }
        
        lineCursor = newlineCursor
        
        let distanceToBottom = scrollView.frame.size.height - lineCursor - todoDescription.frame.origin.y + scrollView.contentOffset.y
        let collapse = distanceToBottom - keyboardHeight
        
        if collapse < 20 {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset = CGPoint(x: self.scrollView.contentOffset.x, y: self.scrollView.contentOffset.y - abs(collapse) + 40)
            })
        }
    }
    
    func removeTextUntilSatisfying(maxNumberOfLines: Int) {
        while numberOfCurrentlyDisplayedLines > maxNumberOfLines {
            todoDescription.text = String(todoDescription.text.dropLast())
            todoDescription.layoutIfNeeded()
        }
    }
    
    //MARK:- KeyboardObserve
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        keyboardHeight = 0
    }
}
