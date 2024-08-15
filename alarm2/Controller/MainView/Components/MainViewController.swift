//
//  MainViewController.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/6.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var tView: UITableView!
    @IBOutlet var alarmAdd: UIBarButtonItem!
    
    // MARK: - Proprtty
        let a = 1
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    func setUI() {
        tableSet()
    }
    func tableSet() {
        tView.register(UINib(nibName: "clockTableViewCell", bundle: nil), forCellReuseIdentifier: clockTableViewCell.identifie)
        tView.dataSource = self
        tView.delegate = self
        
        
    }
    // MARK: - UI Setting
    
    // MARK: - IBAction
    
    @IBAction func alarmAdd(_ sender: Any) {
        let alarmAddVC = alarmAddVC()
        //把跳轉過去的畫面設定為主畫面．這樣才可以使用接下來的跳轉畫面
        let navigationController = UINavigationController(rootViewController: alarmAddVC)
        //self.navigationController?.pushViewController(alarmAddVC, animated: false)
        self.present(navigationController, animated: true)
     }
    // MARK: - Function
    
}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tView.dequeueReusableCell(withIdentifier: clockTableViewCell.identifie, for: indexPath) as! clockTableViewCell
       //cell.lbText!.text = String(self.MessageArray[indexPath.row].Name)
       //cell.lbText2!.text = String(self.MessageArray[indexPath.row].Constent)
       
       return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 110
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a
        
    }
}
