//
//  CompletedTasksViewController.swift
//  TodoList
//
//  Created by Артем Яблоковский on 16.12.2021.
//

import UIKit
import CocoaLumberjack

protocol DecreaseNumberOfDoneTasksDelegate: AnyObject {
    func decreaseNumberOfDoneTask()
    func createRow()
}


class DoneTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let modelData: TestModel
    private let identidier = "tasksIdentifier"
    private var chosedIndexTask: IndexPath = [0,0]
    
    weak var doneTasksDelegate: DecreaseNumberOfDoneTasksDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(model: TestModel) {
        self.modelData = model
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Сделанные дела"
        
        self.setTableView()
    }
    
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let viewCellNib = UINib(nibName: "TodoTableViewCell", bundle: nil)
        tableView.register(viewCellNib, forCellReuseIdentifier: identidier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.doneTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identidier, for: indexPath) as! TodoTableViewCell
        
        let todoItem = modelData.doneTasks[indexPath.row]
        cell.setViews(todoItem)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            modelData.deleteDoneTasks(indexPath.row)
            doneTasksDelegate?.decreaseNumberOfDoneTask()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func deleteRow(_ indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title: "Восстановить", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            self.modelData.returnTask(indexPath.row)
            self.deleteRow(indexPath)
            self.doneTasksDelegate?.decreaseNumberOfDoneTask()
            self.doneTasksDelegate?.createRow()
            
            success(true)
        })
        closeAction.backgroundColor = UIColor(named: "CustomBlue") ?? .blue
        
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosedIndexTask = indexPath
        
        let todoViewController = TodoViewController(modelData.doneTasks[indexPath.row])
        todoViewController.changeTaskDelegate = self
        navigationController?.pushViewController(todoViewController, animated: true)
    }
}

extension DoneTasksViewController: ChangeTaskDelegate {
    func updateTask(_ newTodoItem: TodoItem) {
        modelData.updateDoneTasks(chosedIndexTask.row, newTodoItem)
        tableView.reloadRows(at: [chosedIndexTask], with: .automatic)
        
        DDLogDebug("updateDoneTask \(String(describing: chosedIndexTask.row))")
    }
    
    func deleteTask(_ todoItem: TodoItem) {
        modelData.deleteDoneTasks(chosedIndexTask.row)
        deleteRow(chosedIndexTask)
        doneTasksDelegate?.decreaseNumberOfDoneTask()

        DDLogDebug("deleteDoneTask \(String(describing: chosedIndexTask.row))")
    }
}
