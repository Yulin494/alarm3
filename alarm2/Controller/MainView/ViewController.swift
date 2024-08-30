//
//  ViewController.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/6.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let testVC = MainViewController()
        let alarmVC = MainViewController()
        
        let testController1 = UINavigationController(rootViewController: testVC)
        
        testController1.tabBarItem.image = UIImage(systemName: "globe")
        testController1.tabBarItem.title = "世界時鐘"
        
        
        let testController2 = UINavigationController(rootViewController: alarmVC)
        
        testController2.tabBarItem.image = UIImage(systemName: "alarm")
        testController2.tabBarItem.title = "鬧鐘"
        
       
        let testController3 = UINavigationController(rootViewController: testVC)
        
        testController3.tabBarItem.image = UIImage(systemName: "stopwatch")
        testController3.tabBarItem.title = "碼表"
        
        
        let testController4 = UINavigationController(rootViewController: testVC)
        
        testController4.tabBarItem.image = UIImage(systemName: "timer")
        testController4.tabBarItem.title = "計時器"
        
        viewControllers = [testController1, testController2, testController3, testController4]
        // Do any additional setup after loading the view.
        tabBar.tintColor = .blue
        tabBar.barTintColor = .white // 設置 tab bar 的背景顏色
        tabBar.unselectedItemTintColor = .gray // 設置未選中項目的顏色
        self.selectedIndex = 1
    }
        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController = viewController as? UINavigationController {
            if navController.tabBarItem.title == "鬧鐘" {
                // 這裡執行選擇“鬧鐘”標籤後的導航操作
                let mainVC = MainViewController() // 創建主畫面實例
                navController.setViewControllers([mainVC], animated: true) // 將主畫面設為當前導航堆疊的根視圖控制器
            }
        }
    }
}

