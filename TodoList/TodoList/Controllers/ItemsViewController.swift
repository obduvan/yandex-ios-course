//
//  ItemsViewController.swift
//  TodoList
//
//  Created by Артем Яблоковский on 27.11.2021.
//

import UIKit

class ItemsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }



    @IBAction func newTodoItem(_ sender: Any) {
        present(TodoViewController(), animated: true, completion: nil)
    }
}
