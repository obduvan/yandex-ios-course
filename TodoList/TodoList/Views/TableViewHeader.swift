//
//  TableViewHeader.swift
//  TodoList
//
//  Created by Артем Яблоковский on 16.12.2021.
//

import Foundation
import UIKit

protocol ShowDoneTasksDelegate: AnyObject {
    func showDoneTasks()
}

class TableViewHeader: UIView {
    
    weak var showDoneTaskDelegate: ShowDoneTasksDelegate?
    
    @IBOutlet private weak var numberDoneTasksLabel: UILabel!
    private var numberDoneTasks: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    func updateNumberOfDoneTasks(number: Int) {
        numberDoneTasks += number
        numberDoneTasksLabel.text = String(numberDoneTasks)
    }
    
    private func setupViews(){
        let xibViews = loadFromXib()
        self.addSubview(xibViews)

        xibViews.translatesAutoresizingMaskIntoConstraints = false
        xibViews.heightAnchor.constraint(equalToConstant: 50).isActive = true
        xibViews.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        xibViews.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        xibViews.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibViews.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @IBAction func showDoneTasks(_ sender: Any) {
        showDoneTaskDelegate?.showDoneTasks()
    }
    
    private func loadFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TableViewHeader", bundle: bundle)
        
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
}
