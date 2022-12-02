//
//  weekViewCollectionViewCell.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/22/21.
//

import UIKit

class weekViewCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var dates: [Date] = []
    var originalDate: Date? = nil
    var parentView: firstCalendarViewController? = nil
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = weekCollectionView.dequeueReusableCell(withReuseIdentifier: "dateView", for: indexPath) as? dateViewCollectionViewCell {
            cell.currDate = dates[indexPath.row]
            cell.dateLabel.text = dates[indexPath.row].dateNumber()
            cell.originalDate = originalDate
            cell.setup()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCell = collectionView.cellForItem(at: indexPath) as! dateViewCollectionViewCell
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.parentView?.dayLabel.alpha = 0
            self.parentView?.eventTableView.alpha = 0
        }, completion: {_ in
            self.parentView!.dateEvents = selectedCell.events
            self.parentView!.selectedDate = selectedCell.currDate
            self.parentView!.numRows = selectedCell.events.count
            self.parentView?.eventTableView.reloadData()
            self.parentView?.dayLabel.text = selectedCell.currDate?.dayMonthDate()
            UIView.animate(withDuration: 0.2, animations: {
                self.parentView?.dayLabel.alpha = 1
                self.parentView?.eventTableView.alpha = 1
            })
        })
//        parentView!.dateEvents = selectedCell.events
//        parentView!.selectedDate = selectedCell.currDate
//        parentView!.numRows = selectedCell.events.count
//        parentView?.eventTableView.reloadData()
//        parentView?.dayLabel.text = selectedCell.currDate?.dayMonthDate()
    }
    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
    }
    
}
