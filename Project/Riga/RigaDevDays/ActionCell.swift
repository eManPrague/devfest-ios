//
//  ActionCell.swift
//  RigaDevDays
//
//  Created by Dmitry Beloborodov on 19/02/2017.
//  Copyright © 2017 RigaDevDays. All rights reserved.
//

import UIKit

class ActionCell: UITableViewCell {

    @IBOutlet weak var actionTitle: UILabel!

    @IBOutlet weak var actionImage: UIImageView!
    
    @IBOutlet weak var separatorLineHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

        separatorLineHeightConstraint?.constant = 0.5
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // code common to all your cells goes here
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
