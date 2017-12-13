//
//  Tag.swift
//  RigaDevDays
//
//  Created by Dmitry Beloborodov on 01/02/2017.
//  Copyright © 2017 RigaDevDays. All rights reserved.
//

import Foundation
import Firebase

class Tag: DataObject {

    let title: String?
    let colorCode: String?

    override init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! String
        title = snapshot.key
        
        if title?.isEmpty == false {
            colorCode = snapshotValue
        } else {
            colorCode = "#000000"
        }

        super.init(snapshot: snapshot)
    }
    
    init(title: String) {
        self.title = title
        colorCode = "#000000"
        
        super.init()
    }
}
