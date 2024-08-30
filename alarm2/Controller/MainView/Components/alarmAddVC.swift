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
    var alarmArray: [alarm2] = []
    // var delegate: sendDateToDelgate!
    var alarms: Results<alarm2>!
    var info = ["重複","標籤","提示聲","稍後提醒"]
    var dayNames = ["星期天" , "星期一" , "星期二" , "星期三" , "星期四" , "星期五" , "星期六"]
    var daysNames = ["週日", "週一", "週二", "週三", "週四", "週五", "週六"]
    private var initialDaySelect: [Int] = []
    private var initialVoiceSelect: String = ""
    let switchControl = UISwitch()
    var userMessage: String = ""
    var messageTitle: String = "鬧鐘 "
    var delegate: MessageDelegateFromAlarmaddVC?
    var editingAlarm: alarm2?
    var isEditMode: Bool = false
    let defaultRepeat = "永不"
    let defaultMessage = "鬧鐘"
    let defaultVoicd = "A"
    var reminder: Bool = true
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
            NewAlarm()
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
            repeatDay = "永不"
        } else {
            repeatDay = selectedDayNames.joined(separator: ", ")
        }
        
        
//        print(period)
//        print(formattedTime)
//        print(repeatDay)
//        print(messageTitle)
        print("fileURL : \(realm.configuration.fileURL!)")
        do {
            try realm.write {
                if isEditMode, let alarmToEdit = editingAlarm {
                    alarmToEdit.morning = period
                    alarmToEdit.time = selectedDate
                    alarmToEdit.repeaT = repeatDay
                    alarmToEdit.message = messageTitle.isEmpty ? "鬧鐘 " : messageTitle
                    alarmToEdit.reminder = reminder
                } else {
                    let newAlarm = alarm2(morning: period,
                                         time: selectedDate,
                                         repeaT: repeatDay,
                                         message: messageTitle.isEmpty ? "鬧鐘 " : messageTitle,
                                         reminder: reminder )
                    realm.add(newAlarm)
                }
            }
        } catch {
            print("儲存鬧鐘時發生錯誤：\(error)")
        }
        
        // 調用 delegate 傳值
        self.delegate?.didSendMessageFromAlarmaddVC(self.messageTitle)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteBTN(_ sender: Any) {
        guard let alarmToDelete = editingAlarm else { return }
        
        if alarmToDelete.isInvalidated{
            return
        }
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(alarmToDelete)
            }
           
            // 關閉當前視圖控制器
            //                    self.dismiss(animated: true, completion: nil)
        } catch {
            print("刪除鬧鐘時發生錯誤：\(error)")
        }
        
        // 通知代理鬧鐘已被刪除
//        delegate?.didDeleteAlarm(alarmToDelete)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Function
    func NewAlarm() {
        self.title = "新增鬧鐘"
        deleteButton.isHidden = true
        dayValue.shared.select = []  // 重複設為 "從不"
        messageTitle = defaultMessage
        voiceValue.shared.select = defaultVoicd
        
        // 更新 UI
        reloadUI()
        
    }
    func configureForEditing() {
        guard let alarm = editingAlarm else { return }
        // 設置 UI 元素的初始值
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "HH:mm"
        //let formattedTime = dateFormatter.string(from: alarm.time)
        
        datePicker.date = alarm.time
        messageTitle = alarm.message
        dayValue.shared.select = getDayIndices(from: alarm.repeaT)
        reminder = alarm.reminder
        self.title = "編輯鬧鐘"
        deleteButton.isHidden = false
        reloadUI()
    }
    func getDayIndices(from repeatString: String) -> [Int] {
        switch repeatString {
        case "平日":
            return [1, 2, 3, 4, 5]
        case "週末":
            return [0, 6]
        case "每天":
            return [0, 1, 2, 3, 4, 5, 6]
        case "永不":
            return []
        default:
            return dayNames.indices.filter { dayNames[$0] == repeatString }
        }
    }
    func reloadUI() {
        alarmSetView.reloadData()
    }
    @objc func switchChanged(_ sender: UISwitch) {
        reminder = sender.isOn
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
        //內建的符號
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor.systemGray
        switch info[indexPath.row] {
        case "重複":
            let selectedDayNames = dayValue.shared.select.map { dayNames[$0] }
            var title = selectedDayNames.isEmpty ? "永不" : selectedDayNames.joined(separator: ", ")
            if selectedDayNames == ["星期一", "星期二", "星期三", "星期四", "星期五"] {
                title = "平日 "
            } else if selectedDayNames == dayNames {
                title = "每天 "
            } else if selectedDayNames == ["星期天", "星期六"] {
                title = "週末 "
            } else if selectedDayNames == [""] {
                title = "永不 "
            }
            cell.pickDateLabel.text = "\(title)"
            cell.remindSwithch.isHidden = true
        case "標籤":
            cell.pickDateLabel.text = "\(messageTitle)"
            cell.remindSwithch.isHidden = true
        case "提示聲":
            cell.pickDateLabel.text = "\(voiceValue.shared.select)"
            cell.remindSwithch.isHidden = true
        case "稍後提醒":
            cell.pickDateLabel.text = ""
            cell.remindSwithch.isHidden = false
            cell.remindSwithch.isOn = reminder
            cell.remindSwithch.tag = indexPath.row
            cell.remindSwithch.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
            cell.accessoryType = UITableViewCell.AccessoryType.none
        default:
            cell.pickDateLabel.text = ""
            cell.remindSwithch.isHidden = true
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
        messageTitle = message
        print(userMessage)
        print(messageTitle)
        // 刷新表格視圖
        reloadUI()
    }
}
protocol MessageDelegateFromAlarmaddVC {
    func didSendMessageFromAlarmaddVC(_ message: String)
    func didDeleteAlarm(_ alarm: alarm2)
}
