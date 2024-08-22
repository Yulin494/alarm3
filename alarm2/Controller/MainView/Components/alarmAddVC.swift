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
    @IBOutlet var delteButton: UIButton!
    
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
            let alarm = editingAlarm
        // 設置 UI 元素的初始值
            //datePicker.date = stringToDate(alarm.time)
            //messageTitle = alarm.message
            //dayValue.shared.select = getDayIndices(from: alarm.repeaT)
                
            // 更新標題
            self.title = "編輯鬧鐘"
        } else {
            self.title = "新增鬧鐘"
            delteButton.isHidden = true

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
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.timeStyle = .short
        let formattedDate: String = dateFormatter.string(from: selectedDate)
        
        let selectedDayIndices = dayValue.shared.select
        let selectedDayNames = dayValue.shared.select.map { daysNames[$0] }
        
        var repeatDay: String
            if selectedDayIndices == [1, 2, 3, 4, 5] { // 星期一到五
                repeatDay = "平日"
            } else if selectedDayIndices == [0, 6] { // 星期六和日
                repeatDay = "週末"
            } else if selectedDayIndices == [0, 1, 2, 3, 4, 5, 6] { // 每天
                repeatDay = "每天"
            } else {
                repeatDay = selectedDayNames.joined(separator: ", ")
            }
        
        
        let newAlarm = alarm(time: formattedDate, repeaT: repeatDay,
                             message: messageTitle.isEmpty ? "鬧鐘 >" : messageTitle
)
        print(formattedDate)
        print(repeatDay)
        print(messageTitle)
        print("fileURL : \(realm.configuration.fileURL!)")

        // Save the alarm to Realm
        try! realm.write {
            realm.add(newAlarm)
        }
        
        // Update the alarmArray if needed
        self.alarmArray.append(newAlarm)
        
        //delegate.sendDate(selectedDayNames: "selectedDayNames")
        self.dismiss(animated: true, completion: nil)
        //調用delegate傳值
        self.delegate?.didSendMessageFromAlarmaddVC(self.messageTitle)
        initialDaySelect = dayValue.shared.select
        voiceValue.shared.select = initialVoiceSelect
        if isEditMode, let alarmToEdit = editingAlarm {  // 使用 isEditingMode
            try! realm.write {
                alarmToEdit.time = formattedDate
                alarmToEdit.repeaT = repeatDay
                alarmToEdit.message = messageTitle.isEmpty ? "鬧鐘 >" : messageTitle
            }
        } else {
            let newAlarm = alarm(time: formattedDate, repeaT: repeatDay,
                                 message: messageTitle.isEmpty ? "鬧鐘 >" : messageTitle)
            try! realm.write {
                realm.add(newAlarm)
            }
        }
    }
    @IBAction func deletee(_ sender: Any) {
//        let realm = try! Realm()
//        try realm.write {
//            realm.delete(deleteArrayCell)
//        }
//        self.alarmArray.remove(at: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Function
    
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
}
