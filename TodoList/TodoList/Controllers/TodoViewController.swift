//
//  TodoViewController.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit

class TodoViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var todoDescription: UITextView!
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var dateDivider: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deletingButton: UIButton!
    
    @IBOutlet weak var colorsStackView: TodoColorsView!
    @IBOutlet weak var todoDescriptionView: TodoDescriptionView!

    
    private let keyboardIndent: CGFloat = 30
    private var chosedColor: UIColor = .white
    private var DescriptionTodo: String = ""
    private let deletingButtonStateOn: UIColor = .red
    private let deletingButtonStateOff: UIColor = .lightGray

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboardObervers()
        colorsStackView.delegate = self
        todoDescriptionView.descriptionDelegate = self
        
        dateLabel.text = getFormatData(date: datePicker)
    }

    @IBAction func dateClicked(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            
            if self.datePickerView.isHidden {
                self.datePickerView.isHidden = false
                self.setDateLabel(dateString: self.dateLabel.text ?? "")
        
            }
            else {
                self.datePickerView.isHidden = true
                self.setDateLabelState(close: true)
            }
        })
        dateDivider.isHidden = !dateDivider.isHidden
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {

        let dateString = self.getFormatData(date: sender)
        setDateLabel(dateString: dateString)
    }
    
    private func getFormatData(date: UIDatePicker) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM YYYY"
        return dateFormatter.string(from: date.date)
        
    }
    
    private func setDateLabelState(close: Bool) {
        if close {
            self.dateLabel.isHidden = true
        }
        else {
            self.dateLabel.isHidden = false
        }
    }
    
    private func setDateLabel(dateString: String) {
        guard !dateString.isEmpty else { return }
        
        setDateLabelState(close: false)
        dateLabel.text = dateString
    }
    
    @IBAction func buttonCloseClocked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func changeButtonDeletingState() {
        if DescriptionTodo.isEmpty{
            self.deletingButton.setTitleColor(deletingButtonStateOff, for: .normal)
        }
        else {
            self.deletingButton.setTitleColor(deletingButtonStateOn, for: .normal)
        }
    }
}



extension TodoViewController: ColorsViewDelegate {
    func setChosedColor(color: UIColor) {
        
        self.chosedColor = color
    }
}


extension TodoViewController: DescriptionViewDelegate {
    func setDescription(description: String) {
        
        self.DescriptionTodo = description
        self.changeButtonDeletingState()
    }
}



extension TodoViewController {
    
    public func setKeyboardObervers() {
        NotificationCenter.default.addObserver(self, selector: #selector(TodoViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TodoViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setKeyboardDismiss()
    }
    
    //MARK:- KeyboardObserve
    
    private func setKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            scrollView.contentInset.bottom = keyboardSize.height + keyboardIndent
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
    }
}
