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
    // 儲存從 Realm 查詢的鬧鐘資料
    var alarms: Results<alarm>!
    var alarmArray: [alarm] = []
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        let realm = try! Realm()
        let alarms = realm.objects(alarm.self)
        for alarmss in alarms {
            alarmArray.append(alarmss)
        }
        
        
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
        self.present(navigationController, animated: true)
     }
    // MARK: - Function
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tView.dequeueReusableCell(withIdentifier: clockTableViewCell.identifie, for: indexPath) as! clockTableViewCell
//        let alarm = alarmArray[indexPath.row] // 使用 `alarmArray`
//        cell.setTime.text = formatDate(alarm.time) // 使用 `formatDate` 來顯示時間
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmArray.count
        
    }
}
//extension MainViewController: sendDateToDelgate{
//    func sendDate(selectedDayNames dateSelect: String) {
//        selectedDayNames = 1
//    }
//}
