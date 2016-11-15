//
//  ChecklistItem.swift
//  Checklist
//
//  Created by Yingcai Dong on 2016-09-02.
//  Copyright © 2016 Yingcai Dong. All rights reserved.
//

import Foundation

class checklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
    
    // load files
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    // save files
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    override init() {
        super.init()
    }
}
