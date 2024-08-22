//
//  alarmVC.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/9.
//

import UIKit
import RealmSwift
import AuthenticationServices

class time {
    var hourSelect: Int?
    var minuteSelect: Int?
    var morningSelect: String?
    let morning = ["上午", "下午"]
    let hour = [Int](1...12)
    let minute = [Int](0...59)
    static let timeShared = time()
    private init() {}
}

class alarmAddVC: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var alarmSetView: UITableView!
    @IBOutlet var labelText: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var deleteButton: UIButton!
    
    // MARK: - Proprtty
    var alarmArray: [alarm] = []
   // var delegate: sendDateToDelgate!
    var alarms: Results<alarm>!
    var info = ["重複","標籤","提示聲","稍後提醒"]
    var dayNames = ["星期天" , "星期一" , "星期二" , "星期三" , "星期四" , "星期五" , "星期六"]
    var daysNames = ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]
    private var initialDaySelect: [Int] = []
    private var initialVoiceSelect: String = ""
    let switchControl = UISwitch()
    var userMessage: String = ""
    var messageTitle: String = ""
    var delegate: MessageDelegateFromAlarmaddVC?
    var editingAlarm: alarm?
    var isEditMode: Bool = false
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setupNavigationBar()
        initialDaySelect = dayValue.shared.select
        initialVoiceSelect = voiceValue.shared.select
        
        if isEditMode {
                    configureForEditing()
                } else {
                    self.title = "新增鬧鐘"
                    deleteButton.isHidden = true
                }
            }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarmSetView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didSendMessageFromAlarmaddVC(messageTitle)
    }
    
    // MARK: - UI Setting
    func setUI() {
        tableSet()
    }
    func tableSet() {
        alarmSetView.register(UINib(nibName: "alarmAddTableViewCell", bundle: nil), forCellReuseIdentifier: alarmAddTableViewCell.identifie)
        alarmSetView.dataSource = self
        alarmSetView.delegate = self
    }
    func setupNavigationBar() {
        let saveButton = UIBarButtonItem(title: "儲存", style: .plain , target: self, action: #selector(save))
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain , target: self, action: #selector(cancel))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton

    }
    // MARK: - IBAction

    @objc func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //按下取消後再跳回變成預設的值，而不是已選擇的值
        dayValue.shared.select = initialDaySelect
        voiceValue.shared.select = initialVoiceSelect
    }
    @objc func save(_ sender: Any) {
     
        let realm = try! Realm()
        
        let selectedDate = datePicker.date
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: selectedDate)
        let minute = calendar.component(.minute, from: selectedDate)
        let period = hour >= 12 ? "下午" : "上午"
        let formattedHour = hour % 12 == 0 ? 12 : hour % 12
        let formattedTime = String(format: "%02d:%02d", formattedHour, minute)
        
        let selectedDayIndices = dayValue.shared.select
        let selectedDayNames = dayValue.shared.select.map { daysNames[$0] }
        
        var repeatDay: String
            if selectedDayIndices == [1, 2, 3, 4, 5] { // 星期一到五
                repeatDay = "平日"
            } else if selectedDayIndices == [0, 6] { // 星期六和日
                repeatDay = "週末"
            } else if selectedDayIndices == [0, 1, 2, 3, 4, 5, 6] { // 每天
                repeatDay = "每天"
            } else if selectedDayIndices == [] { // 每天
                repeatDay = "從不"
            } else {
                repeatDay = selectedDayNames.joined(separator: ", ")
            }
        
        
        let newAlarm = alarm(morning: period, time: selectedDate, repeaT: repeatDay,
                             message: messageTitle.isEmpty ? "鬧鐘 >" : messageTitle
)
        print(period)
        print(formattedTime)
        print(repeatDay)
        print(messageTitle)
        print("fileURL : \(realm.configuration.fileURL!)")

        do {
            try realm.write {
                if isEditMode, let alarmToEdit = editingAlarm {
                    alarmToEdit.morning = period
                    alarmToEdit.time = selectedDate
                    alarmToEdit.repeaT = repeatDay
                    alarmToEdit.message = messageTitle.isEmpty ? "鬧鐘 >" : messageTitle
                } else {
                    realm.add(newAlarm)
                }
            }
        } catch {
                    print("儲存鬧鐘時發生錯誤：\(error)")
                }
        if !isEditMode {
                    alarmArray.append(newAlarm)
                }
                
                // 調用 delegate 傳值
        self.delegate?.didSendMessageFromAlarmaddVC(self.messageTitle)
                self.dismiss(animated: true, completion: nil)
            }
        // Save the alarm to Realm
//        try! realm.write {
//            realm.add(newAlarm)
//        }
//
//        // Update the alarmArray if needed
//        self.alarmArray.append(newAlarm)
//
//        //delegate.sendDate(selectedDayNames: "selectedDayNames")
//        self.dismiss(animated: true, completion: nil)
//        //調用delegate傳值
//        self.delegate?.didSendMessageFromAlarmaddVC(self.messageTitle)
//        initialDaySelect = dayValue.shared.select
//        voiceValue.shared.select = initialVoiceSelect
//        if isEditMode, let alarmToEdit = editingAlarm {
//                try! realm.write {
//                    alarmToEdit.time = formattedDate
//                    alarmToEdit.repeaT = repeatDay
//                    alarmToEdit.message = messageTitle.isEmpty ? "鬧鐘 >" : messageTitle
//                }
//            } else {
//                let newAlarm = alarm()
//                newAlarm.uuid = UUID().uuidString
//                newAlarm.time = formattedDate
//                newAlarm.repeaT = repeatDay
//                newAlarm.message = messageTitle.isEmpty ? "鬧鐘 >" : messageTitle
//
//                try! realm.write {
//                    realm.add(newAlarm)
//                }
//            }
//    }
    @IBAction func deleteBTN(_ sender: Any) {
        guard let alarmToDelete = editingAlarm, !alarmToDelete.isInvalidated else { return }

                let realm = try! Realm()
                do {
                    try realm.write {
                        realm.delete(alarmToDelete)
                    }
                    // 通知代理鬧鐘已被刪除
                    delegate?.didDeleteAlarm(alarmToDelete)
                    // 關閉當前視圖控制器
                    self.dismiss(animated: true, completion: nil)
                } catch {
                    print("刪除鬧鐘時發生錯誤：\(error)")
                }
    }
    
    
    // MARK: - Function
    func configureForEditing() {
            guard let alarm = editingAlarm else { return }
            // 設置 UI 元素的初始值
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let formattedTime = dateFormatter.string(from: alarm.time)
            datePicker.date = alarm.time
            messageTitle = alarm.message
            dayValue.shared.select = getDayIndices(from: alarm.repeaT)
            self.title = "編輯鬧鐘"
            deleteButton.isHidden = false
        }
    func getDayIndices(from repeatString: String) -> [Int] {
            switch repeatString {
            case "平日":
                return [1, 2, 3, 4, 5]
            case "週末":
                return [0, 6]
            case "每天":
                return [0, 1, 2, 3, 4, 5, 6]
            case "從不":
                return []
            default:
                return dayNames.indices.filter { dayNames[$0] == repeatString }
            }
        }
}
// MARK: - Extensions
    @objc protocol sendDateToDelgate {
        @objc func sendDate(selecteDate: String)
}
extension alarmAddVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = alarmSetView.dequeueReusableCell(withIdentifier: alarmAddTableViewCell.identifie, for: indexPath) as! alarmAddTableViewCell
        cell.alarmSetLabel.text = info[indexPath.row]
        if info[indexPath.row] == "重複" {
            let selectedDayNames = dayValue.shared.select.map { dayNames[$0] }
            var title = selectedDayNames.isEmpty ? "從不" : selectedDayNames.joined(separator: ", ")
            if selectedDayNames == [ "星期一" , "星期二" , "星期三" , "星期四" , "星期五" ] {
                title = "平日 >"
                cell.pickDateLabel.text = title
            } else if selectedDayNames == ["星期天" , "星期一" , "星期二" , "星期三" , "星期四" , "星期五" , "星期六"] {
                title = "每天 >"
                cell.pickDateLabel.text = title
            } else if selectedDayNames == ["星期天","星期六"] {
                title = "週末 >"
                cell.pickDateLabel.text = title
            } else if selectedDayNames == [] {
                title = "從不 >"
                cell.pickDateLabel.text = title
            } else {
                cell.pickDateLabel.text = title
            }
           
        } else if info[indexPath.row] == "提示聲" {
            let selectedVoiceNames = voiceValue.shared.select
            var title = selectedVoiceNames
            cell.pickDateLabel.text = title
        } else if info[indexPath.row] == "稍後提醒" {
            //view.addSubview(switchControl)
            //switchControl.frame = CGRect(x: 200, y: 200, width: 0, height: 0)
        } else if info[indexPath.row] == "標籤" {
             messageTitle = userMessage.isEmpty ? "鬧鐘 >" : userMessage
            cell.pickDateLabel.text = messageTitle
        } else {
            cell.pickDateLabel.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectPage = info[indexPath.row]
        switch selectPage {
        case "重複":
            let repeatVC = repeatVC()
            repeatVC.delegate = self
            repeatVC.selectDays = dayValue.shared.select
            self.navigationController?.pushViewController(repeatVC, animated: true)
        case "標籤":
            let labelVC = labelVC()
            //傳值步驟5 設定代理
            labelVC.delegate = self
            self.navigationController?.pushViewController(labelVC, animated: true)
        case "提示聲":
            let voiceVC = voiceVC()
            voiceVC.selectVoice = voiceValue.shared.select
            self.navigationController?.pushViewController(voiceVC, animated: true)
        default:
            return
        }
    }
}
extension alarmAddVC: RepeatVCDelegate {
    func didSelectDays(_ selectedDays: [String]) {
        let selectedDayNames = dayValue.shared.select.map { dayNames[$0] }
        let title = selectedDayNames.isEmpty ? "請選擇日期" : selectedDayNames.joined(separator: ", ")
    }
}
//傳值步驟4 在需要的地方做接值
extension alarmAddVC: MessageDelegate {
    func didSendMessage(_ message: String) {
        // 在此處處理接收到的訊息
        userMessage = message
        print(userMessage)
        // 刷新表格視圖
        alarmSetView.reloadData()
    }
}
protocol MessageDelegateFromAlarmaddVC {
    func didSendMessageFromAlarmaddVC(_ message: String)
    func didDeleteAlarm(_ alarm: alarm)
}
