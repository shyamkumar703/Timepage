//
//  classCollectionViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit

class classCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var colorView: UIView!
    var idValues: IDValues? = nil
    
    override func awakeFromNib() {
        colorView.layer.cornerRadius = 2
        let number = Int.random(in: 0..<4)
        switch number {
        case 0:
            colorView.backgroundColor = Colors.yellow
        case 1:
            colorView.backgroundColor = Colors.blue
        case 2:
            colorView.backgroundColor = Colors.red
        case 3:
            colorView.backgroundColor = Colors.green
        default:
            return
        }
    }
    
}
