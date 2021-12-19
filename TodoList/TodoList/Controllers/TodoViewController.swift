//
//  TodoViewController.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit

protocol ChangeTaskDelegate: AnyObject {
    func updateTask(_ newTodoItem: TodoItem)
    
    func deleteTask(_ todoItem: TodoItem)
}

protocol CreateTaskDelegate: AnyObject {
    func addTask(_ todoItem: TodoItem)
}

final class TodoViewController: UIViewController {
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var dateDivider: UIView!
    @IBOutlet private weak var dateSwitcher: UISwitch!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var deletingButton: UIButton!
    @IBOutlet private weak var importanceSwitcher: UISegmentedControl!
    
    @IBOutlet private weak var colorsStackView: ColorsStackView!
    @IBOutlet private weak var todoDescriptionView: TodoDescriptionView!
    
    private let deletingButtonStateOn: UIColor = .red
    private let deletingButtonStateOff: UIColor = .lightGray
    private let keyboardIndent: CGFloat = 30
    
    private var todoItem: TodoItem?
    private var chosedColor: UIColor?
    private var importance: Importance = .notImportant
    private var deadline: Date?
    private var descriptionTodo: String = ""
    
    weak var changeTaskDelegate: ChangeTaskDelegate?
    weak var createTaskDelegate: CreateTaskDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ todoItem: TodoItem?) {
        self.todoItem = todoItem
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorsStackView.delegate = self
        
        setBarItems()
        setKeyboardObervers()
        setTodoData()
    }
    
    private func setTodoData() {
        guard let todoItem = self.todoItem else {
            dateLabel.text = formatDate(datePicker.date)
            return
        }
        
        todoDescriptionView.initDescription(text: todoItem.text)
        
        if let newDeadline = todoItem.deadLine {
            dateLabel.text = formatDate(newDeadline)
            setStateOfDateLabel(close: false)
            datePicker.date = newDeadline
            deadline = newDeadline
            dateSwitcher.isOn = true
            datePicker.isHidden = false
            dateDivider.isHidden = false
        }
        
        importance = todoItem.importance
        
        switch todoItem.importance {
        case .important:
            importanceSwitcher.selectedSegmentIndex = 2
        case .regular:
            importanceSwitcher.selectedSegmentIndex = 1
        case .notImportant:
            importanceSwitcher.selectedSegmentIndex = 0
        }
        
        if let color = todoItem.color {
            colorsStackView.initColorLines(color)
        }
        
        setStateOfDeletingButton()
    }
    
    private func setStateOfDeletingButton() {
        deletingButton.isEnabled = true
        deletingButton.setTitleColor(deletingButtonStateOn, for: .normal)
    }
    
    private func setBarItems() {
        navigationItem.largeTitleDisplayMode = .never
        
        let rightButton = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveTodoItem))
        navigationItem.setRightBarButton(rightButton, animated: true)
        navigationItem.title = "Дело"
    }
    
    @IBAction func openDatePicker(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            if self.datePicker.isHidden {
                self.datePicker.isHidden = false
                self.setDate(date: self.datePicker.date)
                self.deadline = self.datePicker.date
            }
            else {
                self.datePicker.isHidden = true
                self.setStateOfDateLabel(close: true)
                self.deadline = nil
            }
        })
        dateDivider.isHidden = !dateDivider.isHidden
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        deadline = sender.date
        setDate(date: sender.date)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM YYYY"
        return dateFormatter.string(from: date)
    }
    
    private func setStateOfDateLabel(close: Bool) {
        self.dateLabel.isHidden = close
    }
    
    private func setDate(date: Date) {
        let dateString = self.formatDate(date)
        
        setStateOfDateLabel(close: false)
        dateLabel.text = dateString
    }
    
    @IBAction func switchImportance(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 2:
            importance = .important
        case 1:
            importance = .regular
        default:
            importance = .notImportant
        }
    }
    
    @IBAction func deleteTodoItem(_ sender: Any) {
        guard let todoItem = self.todoItem else { return }
        
        changeTaskDelegate?.deleteTask(todoItem)
        
        closeTodoView()
    }
    
    @objc private func saveTodoItem() {
        setDescription()
        
        let newTodoItem = TodoItem(text: descriptionTodo, importance: importance, deadLine: deadline, color: chosedColor)
        
        if self.todoItem != nil {
            changeTaskDelegate?.updateTask(newTodoItem)
        }
        else {
            createTaskDelegate?.addTask(newTodoItem)
        }
        
        closeTodoView()
    }
    
    private func setDescription() {
        if todoDescriptionView.textColor == .lightGray {
            descriptionTodo = "Пустое дело"
        }
        else {
            descriptionTodo = todoDescriptionView.text
        }
    }
    
    private func closeTodoView() {
        navigationController?.popViewController(animated: true)
    }
}


extension TodoViewController: ColorsViewDelegate {
    func setChosedColor(color: UIColor) {
        self.chosedColor = color
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
