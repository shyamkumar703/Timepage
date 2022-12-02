//
//  CalendarViewController.swift
//  timepage-clone
//
//  Created by Shyam Kumar on 1/22/21.
//

import UIKit

var dateArr : [Date] = []
var dateIndex: Int = 12

class CalendarViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    lazy var viewControllerList: [UIViewController] = {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())
        
        var vcArr: [UIViewController] = []
        for i in 0...24 {
            dateArr.append(startDate!)
            vcArr.append(sb.instantiateViewController(identifier: "calendar1"))
            startDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate!)
        }
        
        return vcArr
    }()
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = vcIndex - 1
        
        if nextIndex == -1 {
            return nil
        }
        
        guard viewControllerList.count != nextIndex else { return nil }
        
        guard viewControllerList.count > nextIndex else {
            return nil
        }
        
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = vcIndex + 1
        
        guard previousIndex >= 0 else { return nil }
        
        guard viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vcIndex = viewControllerList.firstIndex(of: pendingViewControllers[0]) else { return }
        dateIndex = vcIndex
    }
    
    
    
    override var prefersStatusBarHidden: Bool
    {
         return true
    }
    
    var startOffset: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        let firstViewController = viewControllerList[12]
        self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
        view.backgroundColor = Colors.darkGray

        // Do any additional setup after loading the view.
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
