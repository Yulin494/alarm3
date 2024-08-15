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
    // hh
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
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var dateButton: UIButton!
    @IBOutlet var voiceButton: UIButton!
    
    // MARK: - Proprtty
    var alarmArray: [alarm] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //pickView.dataSource = self
        //pickView.delegate = self
        
    }
    
    // MARK: - UI Setting
    
    // MARK: - IBAction
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func dateButton(_ sender: Any) {
        let repeatVC = repeatVC()
        self.navigationController?.pushViewController(repeatVC, animated: true)
    }
    @IBAction func voiceButton(_ sender: Any) {
        let voiceVC = voiceVC()
        self.navigationController?.pushViewController(voiceVC, animated: true)
    }
//    @IBAction func saveButton(_ sender: Any) {
//        let realm = try! Realm()
//        let selectDate = datePicker.date
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let formattedDate = dateFormatter.string(from: selectDate)
//            
//        print("Hour: \(String(describing: time.timeShared.hourSelect))")
//        print("Minute: \(String(describing: time.timeShared.minuteSelect))")
//        print("Morning: \(String(describing: time.timeShared.morningSelect))")
//
//        guard let hour = time.timeShared.hourSelect,
//              let minute = time.timeShared.minuteSelect,
//              let morning = time.timeShared.morningSelect
//        else {
//            print("Time selection is incomplete")
//        return
//            }
//        let repeatDay = ""
//        let UserMessage = ""
//        let formattedTime = String(format: "%02d:%02d %@", hour, minute, morning)
//
//        let newAlarm = alarm(time: formattedTime, repeaT: repeatDay, message: UserMessage)
//        try! realm.write{
//            realm.add(newAlarm)
//            }
//
//        //資料庫寫入後，儲存的arr也要一起append
//        self.alarmArray.append(newAlarm)
//        self.dismiss(animated: true, completion: nil)
//    }
    @IBAction func saveButton(_ sender: Any) {
     
        let realm = try! Realm()
        
        let selectedDate = datePicker.date
        
        // Format the date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        // Create a new alarm instance
        let repeatDay = "" // Replace with actual repeat logic
        let userMessage = "" // Replace with actual message logic
        let newAlarm = alarm(time: formattedDate, repeaT: repeatDay, message: userMessage)
        print(formattedDate)
        // Save the alarm to Realm
        try! realm.write {
            realm.add(newAlarm)
        }
        
        // Update the alarmArray if needed
        self.alarmArray.append(newAlarm)
        
        // Dismiss the view controller
        self.dismiss(animated: true, completion: nil)
    

    }
    
    // MARK: - Function
//    func datePickerChanged(datePicker:UIDatePicker) {
//        // 設置要顯示在 UILabel 的日期時間格式
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//
//      更新 UILabel 的內容
//        myLabel.text = formatter.stringFromDate(
//          datePicker.date)
//    }
}
// MARK: - Extensions

//extension alarmAddVC : UIPickerViewDelegate,UIPickerViewDataSource{
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 3   //    回傳行直列數
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if component == 0 {
//            return time.timeShared.morning.count
//        }else if component == 1{
//            return time.timeShared.hour.count
//        }else {
//            return time.timeShared.minute.count
//        }
//    }
//
//    //回傳每一直列的行列數（component 指的是選到哪個直列）
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        switch component {
//        case 0:
//            return time.timeShared.morning[row]
//        case 1:
//            return String(time.timeShared.hour[row])
//        case 2:
//            return String(time.timeShared.minute[row])
//        default:
//            return nil
//        }
//    }                 //顯示每一行列給的值（如果是個位數，前面補 0）
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        switch component {
//        case 0:
//            time.timeShared.morningSelect = time.timeShared.morning[row]
//            print(time.timeShared.morning[row])
//        case 1:
//            time.timeShared.hourSelect = time.timeShared.hour[row]
//            print(time.timeShared.hour[row])
//        case 2:
//            time.timeShared.minuteSelect = time.timeShared.minute[row]
//            print(time.timeShared.minute[row])
//        default:
//            break
//        }
//    }          //將選取的值放到 hour_select 變數和 minute_select變數
//}
