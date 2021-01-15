//
//  dayDetailsViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/14/21.
//

import UIKit
import Hero

class dayDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scheduleLabel: UILabel!
    @IBOutlet weak var todoListLabel: UILabel!
    
    let numCells = 5
    let numTodo = 5
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return numCells
        } else {
            return numTodo
        }
    }
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            if let cell = classCollectionView.dequeueReusableCell(withReuseIdentifier: "classView", for: indexPath) as? classCollectionViewCell {
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                cell.backgroundColor = Colors.lighterBlue
                
                
                return cell
            }
            return UICollectionViewCell()
        } else {
            if let cell = todoCollectionView.dequeueReusableCell(withReuseIdentifier: "todoView", for: indexPath) as? todoCollectionViewCell {
                cell.layer.cornerRadius = 10
                cell.layer.masksToBounds = true
                cell.backgroundColor = Colors.lighterBlue
                
                return cell
            }
            return UICollectionViewCell()
        }
    }
    
    @IBOutlet weak var classCollectionView: UICollectionView!
    @IBOutlet weak var classCollectionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var todoCollectionView: UICollectionView!
    @IBOutlet weak var todoCollectionHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classCollectionView.delegate = self
        classCollectionView.dataSource = self
        todoCollectionView.delegate = self
        todoCollectionView.dataSource = self
        
        view.backgroundColor = Colors.darkBlue
        self.hero.modalAnimationType = .zoomOut
        
        classCollectionHeightConstraint.constant = CGFloat(numCells * 63)
        todoCollectionHeightConstraint.constant = CGFloat(numTodo * 63)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToRightSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToLeftSwipeGesture))
        swipeRight.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func respondToRightSwipeGesture() {
        switchDay()
    }
    
    @objc func respondToLeftSwipeGesture() {
        switchDay()
        
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func switchDay() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.dayLabel.alpha = 0
            self.dateLabel.alpha = 0
            self.scheduleLabel.alpha = 0
            self.todoListLabel.alpha = 0
            self.classCollectionView.alpha = 0
            self.todoCollectionView.alpha = 0
        }, completion: {fin in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.dayLabel.alpha = 1
                self.dateLabel.alpha = 1
                self.scheduleLabel.alpha = 1
                self.todoListLabel.alpha = 1
                self.classCollectionView.alpha = 1
                self.todoCollectionView.alpha = 1
            }, completion: nil)
        })
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
