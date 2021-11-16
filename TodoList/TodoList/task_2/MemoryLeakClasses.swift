//
//  MemoryLeakClasses.swift
//  TodoList
//
//  Created by Артем Яблоковский on 12.11.2021.
//

import Foundation

class MemoryLeak1 {
    
    //must be: "weak var ..."
    var memoryLeak2: MemoryLeak2?
    
    init(obj : MemoryLeak2?){
        self.memoryLeak2 = obj
    }
}

class MemoryLeak2{
    var memoryLeak1: MemoryLeak1?
}
