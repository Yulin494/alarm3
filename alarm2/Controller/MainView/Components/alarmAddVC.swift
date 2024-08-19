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
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    // MARK: - Proprtty
    var alarmArray: [alarm] = []
    var delegate: sendDateToDelgate!
    var alarms: Results<alarm>!
    var info = ["重複","標籤","提示聲","稍後提醒"]
    var dayNames = ["星期天" , "星期一" , "星期二" , "星期三" , "星期四" , "星期五" , "星期六"]
    private var initialDaySelect: [Int] = []
    private var initialVoiceSelect: String = ""
    let switchControl = UISwitch()

    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        initialDaySelect = dayValue.shared.select
        initialVoiceSelect = voiceValue.shared.select
    }
    func setUI() {
        tableSet()
    }
    func tableSet() {
        alarmSetView.register(UINib(nibName: "alarmAddTableViewCell", bundle: nil), forCellReuseIdentifier: alarmAddTableViewCell.identifie)
        alarmSetView.dataSource = self
        alarmSetView.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alarmSetView.reloadData()
    }
    
    // MARK: - UI Setting
    
    // MARK: - IBAction
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //按下取消後再跳回變成預設的值，而不是已選擇的值
        dayValue.shared.select = initialDaySelect
        voiceValue.shared.select = initialVoiceSelect
    }
    @IBAction func saveButton(_ sender: Any) {
     
        let realm = try! Realm()
        
        let selectedDate = datePicker.date
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_TW")
        dateFormatter.timeStyle = .short
        let formattedDate: String = dateFormatter.string(from: selectedDate)
        
        
        let repeatDay = ""
        let userMessage = ""
        let newAlarm = alarm(time: formattedDate, repeaT: repeatDay, message: userMessage)
        print(formattedDate)
        
        print("fileURL : \(realm.configuration.fileURL!)")

        // Save the alarm to Realm
        try! realm.write {
            realm.add(newAlarm)
        }
        
        // Update the alarmArray if needed
        self.alarmArray.append(newAlarm)
        
        //delegate.sendDate(selectedDayNames: "selectedDayNames")
        self.dismiss(animated: true, completion: nil)
        initialDaySelect = dayValue.shared.select
        voiceValue.shared.select = initialVoiceSelect
    }
    @IBAction func labelText(_ sender: Any) {
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
            }else if selectedDayNames == ["星期天" , "星期一" , "星期二" , "星期三" , "星期四" , "星期五" , "星期六"] {
                title = "每天 >"
                cell.pickDateLabel.text = title
            }else if selectedDayNames == ["星期天","星期六"] {
                title = "週末 >"
                cell.pickDateLabel.text = title
            }else if selectedDayNames == [] {
                title = "從不 >"
                cell.pickDateLabel.text = title
            }else {
                cell.pickDateLabel.text = title
            }
           
        }else if info[indexPath.row] == "提示聲" {
            let selectedVoiceNames = voiceValue.shared.select
            var title = selectedVoiceNames
            cell.pickDateLabel.text = title
        }else if info[indexPath.row] == "稍後提醒" {
            //view.addSubview(switchControl)
            //switchControl.frame = CGRect(x: 200, y: 200, width: 0, height: 0)
        }else {
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
