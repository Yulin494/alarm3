//
//  MainViewController.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/6.
//

import UIKit
import RealmSwift
import UserNotifications

class MainViewController: UIViewController, UNUserNotificationCenterDelegate {
    // MARk: - IBOutlet
    @IBOutlet var tView: UITableView!
    //    @IBOutlet var alarmAdd: UIBarButtonItem!
    
    // MARK: - Proprtty
    // 儲存從 Realm 查詢的鬧鐘資料
    var alarms: Results<alarm3>!
    var alarmArray: [alarm3] = []
    var deleteArrayCell: alarm3?
    var userMessage: String = ""
    var isEditingMode: Bool = false
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        loadAlarms()
        //createNotificationContent()
        setUpNotificationContent()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAlarms()
    }
    // MARK: - UI Setting
    
    func setUI() {
        setupNavigationBar()
        tableSet()
    }
    func tableSet() {
        tView.register(UINib(nibName: "clockTableViewCell", bundle: nil), forCellReuseIdentifier: clockTableViewCell.identifie)
        tView.dataSource = self
        tView.delegate = self
        
    }
    func loadAlarms() {
        do {
            let realm = try Realm()
            let alarms = realm.objects(alarm3.self).sorted(byKeyPath: "time", ascending: true)
            alarmArray = Array(alarms)
            tView.reloadData()
        } catch {
            print("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func setupNavigationBar() {
        let height: CGFloat = 10 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        navigationController?.navigationBar.frame = CGRect(x: 0, y: -20, width: bounds.width, height: height)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        self.title = "鬧鐘"
        let saveButton = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(alarmAdd))
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
        //toggle切換布林值
        isEditingMode.toggle()
        tView.setEditing(isEditingMode, animated: true)
        navigationItem.leftBarButtonItem?.title = isEditingMode ? "完成" : "編輯"
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
        //對集合內的當前元素做更改
        alarmArray.forEach { $0.message = message }
        tView.reloadData()
    }
    //    func formatAlarmTime(alarm: alarm) -> String {
    //        return "\(alarm.morning) \(alarm.time)"
    //    }
    
    func setUpNotificationContent() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.carPlay,.sound]) { (granted, error) in
            if granted {
                print("允許開啟")
            }else{
                print("拒絕接受開啟")
            }
        }
        UNUserNotificationCenter.current().delegate = self
    }
    @objc func switchChanged(_ sender: UISwitch) {
        let index = sender.tag
        guard index < alarmArray.count else { return }
        
        let alarm = alarmArray[index]
        do {
            let realm = try Realm()
            try realm.write {
                alarm.isEnabled = sender.isOn
            }
            
                        if sender.isOn {
                            //createNotificationContent(for: alarm)
                            print("on")
                        } else {
                            cancelNotification(for: alarm)
                        }
            
            if let cell = tView.cellForRow(at: IndexPath(row: index, section: 0)) as? clockTableViewCell {
                updateCellAppearance(cell, isEnabled: sender.isOn)
            }
        } catch {
            print("更新鬧鐘狀態時發生錯誤：\(error)")
        }
    }
    
    func updateCellAppearance(_ cell: clockTableViewCell, isEnabled: Bool) {
        let color: UIColor = isEnabled ? .black : .gray
        cell.repeatDayAndMessage.textColor = color
        cell.morning.textColor = color
        cell.setTime.textColor = color
    }
    func cancelNotification(for alarm: alarm3) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
        print("通知顯示：\(notification)")
    }
}
// MARK: - Extensions
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tView.dequeueReusableCell(withIdentifier: clockTableViewCell.identifie, for: indexPath) as! clockTableViewCell
        //確保索引有效，防止超過範圍
        if indexPath.row < alarmArray.count {
            let alarm = alarmArray[indexPath.row]
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "#zh_TW")
            dateFormatter.dateFormat = " h:mm"
            cell.morning.text = alarm.morning
            cell.setTime.text = dateFormatter.string(from: alarm.time)
            if alarm.repeaT == "永不" {
                cell.repeatDayAndMessage.text = "\(alarm.message)"
            } else {
                cell.repeatDayAndMessage.text = "\(alarm.message) ， \(alarm.repeaT)"
            }
            cell.OnOffSwitch.isOn = alarm.isEnabled
            cell.OnOffSwitch.tag = indexPath.row
            cell.OnOffSwitch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            updateCellAppearance(cell, isEnabled: alarm.isEnabled)
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "🛏睡眠｜起床鬧鐘"
        case 1:
            return "其他"
        default:
            return ""
        }
    }
}

    
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
        loadAlarms()
    }
    func didDeleteAlarm(_ alarm: alarm3) {
        if let index = alarmArray.firstIndex(where: { $0.uuid == alarm.uuid }) {
            alarmArray.remove(at: index)
            tView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            tView.reloadData()
        }
    }
}
