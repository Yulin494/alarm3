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
    @IBOutlet var labelText: UITextField!
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
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        // Create a new alarm instance
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
        
        // Dismiss the view controller
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
        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let selectedDayNames = dayValue.shared.select.map { dayNames[$0] }
        let title = selectedDayNames.isEmpty ? "請選擇日期" : selectedDayNames.joined(separator: ", ")
        if selectedDayNames == [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"] {
            dateButton.setTitle("平日 >", for: .normal)
        }else if selectedDayNames == ["Sunday","Saturday"] {
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
//    func didSelectVoice(_ voice: String) {
//        voiceValue.shared.select = voice
//        updateVoiceButtonTitle()
//        }

}

