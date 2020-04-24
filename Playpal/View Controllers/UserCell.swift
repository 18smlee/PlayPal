//
//  UserCell.swift
//  Playpal
//
//  Created by Samantha Lee on 4/23/20.
//  Copyright © 2020 Samantha Lee. All rights reserved.
//

import Foundation
import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet weak var dogName: UILabel!
    
    func setData(user: User) {
        print(user.pupName)
        dogName.text = user.pupName
    }
}
