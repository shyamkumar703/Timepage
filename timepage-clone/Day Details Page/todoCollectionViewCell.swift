//
//  todoCollectionViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/15/21.
//

import UIKit

class todoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskDue: UILabel!
    @IBOutlet weak var accentView: UIView!
    
    override func awakeFromNib() {
        accentView.layer.cornerRadius = 2
        let number = Int.random(in: 0..<4)
        switch number {
        case 0:
            accentView.backgroundColor = Colors.yellow
        case 1:
            accentView.backgroundColor = Colors.blue
        case 2:
            accentView.backgroundColor = Colors.red
        case 3:
            accentView.backgroundColor = Colors.green
        default:
            return
        }
    }
    
}
