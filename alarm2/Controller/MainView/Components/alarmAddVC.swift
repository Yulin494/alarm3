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
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var voiceButton: UIButton!
    
    // MARK: - Proprtty
    var alarmArray: [alarm] = []
    var delegate: sendDateToDelgate!
    var alarms: Results<alarm>!
    var info = ["重複","標籤","提示聲","稍後提醒"]
    var dayNames = ["星期天" , "星期一" , "星期二" , "星期三" , "星期四" , "星期五" , "星期六"]
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    func setUI() {
        tableSet()
    }
    func tableSet() {
        alarmSetView.register(UINib(nibName: "alarmAddTableViewCell", bundle: nil), forCellReuseIdentifier: alarmAddTableViewCell.identifie)
        alarmSetView.dataSource = self
        alarmSetView.delegate = self
        
        
    }
    
    // MARK: - UI Setting
    
    // MARK: - IBAction
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dateButton(_ sender: Any) {
        let repeatVC = repeatVC()
        repeatVC.selectDays = dayValue.shared.select
        self.navigationController?.pushViewController(repeatVC, animated: true)
        repeatVC.navigationController?.delegate = self
    }
    @IBAction func voiceButton(_ sender: Any) {
        let voiceVC = voiceVC()
        voiceVC.selectVoice = voiceValue.shared.select
        self.navigationController?.pushViewController(voiceVC, animated: true)
        voiceVC.navigationController?.delegate = self
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
    

    }
    @IBAction func labelText(_ sender: Any) {
    }
    
    // MARK: - Function
    
}
// MARK: - Extensions
extension alarmAddVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if viewController is alarmAddVC {
            updateDateButtonTitle()
            updateVoiceButtonTitle()
        }
    }
    
    func updateDateButtonTitle() {
        let selectedDayNames = dayValue.shared.select.map { dayNames[$0] }
        let title = selectedDayNames.isEmpty ? "請選擇日期" : selectedDayNames.joined(separator: ", ")
        if selectedDayNames == [ "星期一" , "星期二" , "星期三" , "星期四" , "星期五" ] {
            dateButton.setTitle("平日 >", for: .normal)
        }else if selectedDayNames == ["星期天","星期六"] {
            dateButton.setTitle("週末 >", for: .normal)
        }else {
            dateButton.setTitle(title, for: .normal)
        }
        //dateButton.setTitle(title, for: .normal)
    }
    func updateVoiceButtonTitle() {
        //let voiceNames = ["A", "B", "C", "D", "E", "F", "G"]
        let selectedVoiceNames = voiceValue.shared.select
        let title = selectedVoiceNames
        voiceButton.setTitle(title, for: .normal)
    }

}
    @objc protocol sendDateToDelgate {
        @objc func sendDate(selecteDate: String)
}
extension alarmAddVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = alarmSetView.dequeueReusableCell(withIdentifier: alarmAddTableViewCell.identifie, for: indexPath) as! alarmAddTableViewCell
        cell.alarmSetLabel.text = info[indexPath.row]
        cell.pickDateLabel.text = title
        print(title)
        //cell.pickDateLabel.text = title
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
            repeatVC.navigationController?.delegate = self
        case "標籤":
            let labelVC = labelVC()
            self.navigationController?.pushViewController(labelVC, animated: true)
            labelVC.navigationController?.delegate = self
        case "提示聲":
            let voiceVC = voiceVC()
            voiceVC.selectVoice = voiceValue.shared.select
            self.navigationController?.pushViewController(voiceVC, animated: true)
            voiceVC.navigationController?.delegate = self
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
