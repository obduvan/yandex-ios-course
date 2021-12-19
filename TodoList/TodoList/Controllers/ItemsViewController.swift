//
//  ItemsViewController.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit
import CocoaLumberjack


final class ItemsViewController: UIViewController {
    
    private let modelData: TestModel
    private let identidier = "tasksIdentifier"
    private var countDoneTasks: Int = 0
    private var tablerViewHeader = TableViewHeader()
    private var chosedIndexTask: IndexPath = [0, 0]
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ modelData: TestModel) {
        self.modelData = modelData
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Дела"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.setTableView()
    }
    
    @IBAction func bottomButtomClicked(_ sender: Any) {
        let todoViewController = TodoViewController(nil)
        todoViewController.createTaskDelegate = self
        
        navigationController?.pushViewController(todoViewController, animated: true)
    }
}


extension ItemsViewController: ShowDoneTasksDelegate {
    func showDoneTasks() {
        let doneTasksViewController = DoneTasksViewController(model: modelData)
        doneTasksViewController.doneTasksDelegate = self
        navigationController?.pushViewController(doneTasksViewController, animated: true)
    }
}

extension ItemsViewController: DoneTaskViewControllerDelegate {
    func decreaseNumberOfDoneTask() {
        tablerViewHeader.updateNumberOfDoneTasks(number: -1)
    }
    
    func createRow() {
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
}


extension ItemsViewController: UITableViewDelegate, UITableViewDataSource {
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        setTableViewHeader()
        
        let viewCellNib = UINib(nibName: "TodoTableViewCell", bundle: nil)
        tableView.register(viewCellNib, forCellReuseIdentifier: identidier)
    }
    
    private func setTableViewHeader() {
        tablerViewHeader = TableViewHeader()
        tablerViewHeader.showDoneTaskDelegate = self
        
        let height = tablerViewHeader.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = tablerViewHeader.frame
        frame.size.height = height
        tablerViewHeader.frame = frame
        
        tableView.tableHeaderView = tablerViewHeader
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            modelData.deleteTasks(indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identidier, for: indexPath) as! TodoTableViewCell
        
        cell.accessoryType = .disclosureIndicator
        
        let todoItem = self.modelData.tasks[indexPath.row]
        cell.setViews(todoItem)
        
        return cell
    }
    
    private func deleteRow(_ indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let closeAction = UIContextualAction(style: .normal, title: "Выполнено", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.modelData.transferDoneTask(indexPath.row)
            self.deleteRow(indexPath)
            self.tablerViewHeader.updateNumberOfDoneTasks(number: 1)
            
            success(true)
        })
        closeAction.backgroundColor = UIColor(named: "DoneTaskColor") ?? .green
        
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosedIndexTask = indexPath
        let todoViewController = TodoViewController(modelData.tasks[indexPath.row])
        todoViewController.changeTaskDelegate = self
        navigationController?.pushViewController(
            todoViewController , animated: true)
    }
}


extension ItemsViewController: ChangeTaskDelegate, CreateTaskDelegate {
    func updateTask(_ newTodoItem: TodoItem) {
        modelData.updateTasks(chosedIndexTask.row, newTodoItem)
        tableView.reloadRows(at: [chosedIndexTask], with: .automatic)
        
        DDLogDebug("updateTask \(String(describing: chosedIndexTask.row))")
    }
    
    func deleteTask(_ todoItem: TodoItem) {
        modelData.deleteTasks(chosedIndexTask.row)
        deleteRow(chosedIndexTask)
        
        DDLogDebug("deleteTask \(String(describing: chosedIndexTask.row))")
    }
    
    func addTask(_ todoItem: TodoItem) {
        modelData.addTasks(todoItem)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        
        DDLogDebug("addTask \(String(describing: chosedIndexTask.row))")
    }
}
