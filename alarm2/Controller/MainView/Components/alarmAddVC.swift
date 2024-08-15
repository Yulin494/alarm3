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
    
    // MARK: - Function

}
// MARK: - Extensions


