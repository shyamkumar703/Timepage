//
//  ViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit
import Hero

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dayArr = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        720
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? dayTableViewCell {
            if indexPath.row % 2 == 0 {
                cell.backView.backgroundColor = Colors.darkBlue
            } else {
                cell.backView.backgroundColor = Colors.lightBlue
            }
            if indexPath.row == 365 {
                cell.dayLabel.textColor = Colors.royalPurple
                cell.dateLabel.textColor = Colors.royalPurple
            }
            cell.dayLabel.text = dayArr[indexPath.row % 7]
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDay", sender: self)
    }
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        monthLabel.rotate(degrees: 90, clockwise: false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.scrollToRow(at: IndexPath(row: 365, section: 0), at: .middle, animated: false)
        self.view.backgroundColor = Colors.darkBlue
        monthLabel.textColor = Colors.lighterBlue
    }


}

extension UILabel {
    func rotate(degrees: Int , clockwise: Bool)
    {
        let x  = 180 / degrees
        if (clockwise)
        {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / CGFloat(x))
        }
        else
        {
            self.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / CGFloat(x))
        }
    }
}

