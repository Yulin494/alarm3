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
    var userMessage: String = ""
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setUI()
        loadAlarms()
    }

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
        do {
            let realm = try Realm()
            let alarms = realm.objects(alarm.self).sorted(byKeyPath: "time", ascending: true)
            alarmArray = Array(alarms)
            tView.reloadData()
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        self.title = "鬧鐘"
        let saveButton = UIBarButtonItem(title: "+", style: .plain , target: self, action: #selector(alarmAdd))
        navigationItem.rightBarButtonItem = saveButton
        let editButton = UIBarButtonItem(title: "編輯", style: .plain , target: self, action: #selector(alarmEdit))
        navigationItem.leftBarButtonItem = editButton
    }
    // MARK: - IBAction
    
    @objc func alarmAdd() {
        let alarmAddVC = alarmAddVC()
        //把跳轉過去的畫面設定為主畫面．這樣才可以使用接下來的跳轉畫面
        alarmAddVC.delegate = self
        let navigationController = UINavigationController(rootViewController: alarmAddVC)
        self.present(navigationController, animated: true)
     }
    @objc func alarmEdit() {
        
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
//    func formatAlarmTime(alarm: alarm) -> String {
//        return "\(alarm.morning) \(alarm.time)"
//    }

}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tView.dequeueReusableCell(withIdentifier: clockTableViewCell.identifie, for: indexPath) as! clockTableViewCell
        if indexPath.row < alarmArray.count {
            let alarm = alarmArray[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "#zh_TW")
            dateFormatter.dateFormat = " h:mm"
            cell.morning.text = alarm.morning
            cell.setTime.text = dateFormatter.string(from: alarm.time)
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
                self.alarmArray.remove(at: indexPath.row)
                self.tView.deleteRows(at: [indexPath], with: .automatic)
                completionHandler(true)
                }catch {
                    print("刪除鬧鐘時發生錯誤：\(error)")
                    completionHandler(false)
                }
            } else {
                completionHandler(false)
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectAlarm = alarmArray[indexPath.row]
        let alarmAddVC = alarmAddVC()
        
        alarmAddVC.editingAlarm = selectAlarm
        alarmAddVC.isEditMode = true
               
               // 設置代理
        alarmAddVC.delegate = self
               
               // 使用導航控制器呈現 alarmAddVC
        let navigationController = UINavigationController(rootViewController: alarmAddVC)
        self.present(navigationController, animated: true)
        }
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            switch section {
//            case 0:
//                return "🛏睡眠｜起床鬧鐘"
//            case 1:
//                return "其他"
//            default:
//                return ""
//            }
//        }
// MainViewController.swift
extension MainViewController: sendDateToDelgate {
    func sendDate(selecteDate selectedDayNames: String) {
        // 實現這個方法
    }
}
extension MainViewController: MessageDelegateFromAlarmaddVC {
    func didSendMessageFromAlarmaddVC(_ message: String) {
        // 在此處處理接收到的訊息
        userMessage = message
        print(userMessage)
        print(123)
        // 刷新表格視圖
        //tView.reloadData()
        loadAlarms()
    }
    func didDeleteAlarm(_ alarm: alarm) {
        if let index = alarmArray.firstIndex(where: { $0.uuid == alarm.uuid }) {
            alarmArray.remove(at: index)
            tView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }
}
