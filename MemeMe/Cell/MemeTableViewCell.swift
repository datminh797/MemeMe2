//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Android on 26/05/2022.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MemeTableViewCell"
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
}
