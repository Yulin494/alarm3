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
//    @IBOutlet var alarmAdd: UIBarButtonItem!
    
    // MARK: - Proprtty
    // 儲存從 Realm 查詢的鬧鐘資料
    var alarms: Results<alarm>!
    var alarmArray: [alarm] = []
    var deleteArrayCell: alarm?
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUI()
        loadAlarms()
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        tView.reloadData()
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        tView.reloadData()
//    }
    // MARK: - UI Setting
    
    func setUI() {
        tableSet()
        setupNavigationBar()
    }
    func tableSet() {
        tView.register(UINib(nibName: "clockTableViewCell", bundle: nil), forCellReuseIdentifier: clockTableViewCell.identifie)
        tView.dataSource = self
        tView.delegate = self
    }
    func loadAlarms() {
        let realm = try! Realm()
        let alarms = realm.objects(alarm.self).sorted(byKeyPath: "time", ascending: true)
        alarmArray = Array(alarms)
        tView.reloadData()
    }
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.title = "鬧鐘"
        let saveButton = UIBarButtonItem(title: "+", style: .plain , target: self, action: #selector(alarmAdd))
        navigationItem.rightBarButtonItem = saveButton
        let editButton = UIBarButtonItem(title: "編輯", style: .plain , target: self, action: #selector(alarmAdd))
        navigationItem.leftBarButtonItem = editButton
    }
    // MARK: - IBAction
    
    @objc func alarmAdd() {
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
    func didSendMessage(_ message: String) {
            // 在此處處理接收到的訊息
            print("接收到的訊息: \(message)")
            
            // 刷新表格視圖
            alarmArray.forEach { $0.message = message }
            tView.reloadData()
    }
}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tView.dequeueReusableCell(withIdentifier: clockTableViewCell.identifie, for: indexPath) as! clockTableViewCell
        if indexPath.row < alarmArray.count {
            let alarm = alarmArray[indexPath.row]
            cell.setTime.text = alarm.time
            cell.repeatDayAndMessage.text = alarm.repeaT
            //cell.repetitionLabel.text = alarm.repeaT
            }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarmArray.count
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            if indexPath.row < self.alarmArray.count {
                let deleteArrayCell = self.alarmArray[indexPath.row]
                let realm = try! Realm()
                do {
                    try realm.write {
                        realm.delete(deleteArrayCell)
                    }
                }catch {
                    print("刪除鬧鐘時發生錯誤：\(error)")
                    completionHandler(false)
                }
                self.alarmArray.remove(at: indexPath.row)
                self.tView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
            }else {
                completionHandler(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])

    }
}
// MainViewController.swift
extension MainViewController: sendDateToDelgate {
    func sendDate(selecteDate selectedDayNames: String) {
        // 實現這個方法
    }
}

// alarmAddVC.swift
//extension MainViewController: MessageDelegate {
//    func didSendMessage(_ message: String) {
//        // 在此處處理接收到的訊息
//        userMessage = message
//
//        // 刷新表格視圖
//        alarmSetView.reloadData()
//    }
//}
