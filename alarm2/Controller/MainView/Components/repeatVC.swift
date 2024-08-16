//
//  repeatVC.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/13.
//

import UIKit

class dayValue {
    var select = [0,1,2,3,4,5,6]
    static let shared = dayValue()
    private init() {}
}

class repeatVC: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var dateView: UITableView!
    
    // MARK: - Proprtty
    var day = ["Every Sonday" , "Every Monday" , "Every Tuesday" , "Every Wednesday" , "Every Thursday" , "Every Friday" , "Every Saturday"]
    var selectDays: [Int] = []
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
    }
    func setUI() {
        tableSet()
    }
    func tableSet() {
        dateView.register(UINib(nibName: "repeatTableViewCell", bundle: nil), forCellReuseIdentifier: repeatTableViewCell.identifier)
        dateView.dataSource = self
        dateView.delegate = self
    }
    // MARK: - UI Setting
    
    // MARK: - IBAction
    
    // MARK: - Function
//    func updateButton() {
//        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
//        let selectedDayNames = selectDays.map { dayNames[$0] }
//        let title = selectedDayNames.isEmpty ? "Select Days" : selectedDayNames.joined(separator: ", ")
//        dateButton.setTitle(title, for: .normal)
//    }
}
// MARK: - Extensions
extension  repeatVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repeatTableViewCell", for: indexPath) as! repeatTableViewCell
        cell.dateLabel!.text = day[indexPath.row]
    //這邊就是根據 day[indexPath.row] 的陣列內容印出星期六～星期日
        if dayValue.shared.select.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }                //這邊是利用 .accessoryType 的內建函式去幫有在被選擇到的天數印上打勾的樣式，在單例陣列裡的會被打勾，沒有的話就不會印出
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dayValue.shared.select.contains(indexPath.row) {
            dayValue.shared.select = dayValue.shared.select.filter{$0 != indexPath.row}
        }
        else {
            dayValue.shared.select.append(indexPath.row)
        }
        //遞減排序
        dayValue.shared.select.sort(by: <)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
//這邊就是判斷當Cell被點擊到的時候需要把代表那個星期的數字放進單例陣列裡（dayValue.shared.select）

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return day.count
    }                //需要印出的 Cell 數量
}
