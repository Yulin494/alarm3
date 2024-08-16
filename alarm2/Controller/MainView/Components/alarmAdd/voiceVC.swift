//
//  voiceVC.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/13.
//

import UIKit

class voiceValue {
    var select: String {
            get {
                return UserDefaults.standard.string(forKey: "selectedVoice") ?? "A"
            }
            set {
                UserDefaults.standard.set(newValue, forKey: "selectedVoice")
            }
        }
    static let shared = voiceValue()
    private init() {}
}

class voiceVC: UIViewController {
    // MARk: - IBOutlet
    @IBOutlet var voiceView: UITableView!
    
    // MARK: - Proprtty
    var voice = ["A" , "B" , "C" , "D" , "E" , "F" , "G"]
    var selectVoice = "A"
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        selectVoice = voiceValue.shared.select
    }
    func setUI() {
        tableSet()
    }
    func tableSet() {
        voiceView.register(UINib(nibName: "voiceTableViewCell", bundle: nil), forCellReuseIdentifier: voiceTableViewCell.identifie)
        
        voiceView.dataSource = self
        voiceView.delegate = self
    }
    // MARK: - UI Setting
    
    // MARK: - IBAction
    
    // MARK: - Function
    
}
// MARK: - Extensions
extension  voiceVC : UITableViewDelegate , UITableViewDataSource {
    //需要印出的 Cell 數量
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voice.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "voiceTableViewCell", for: indexPath) as! voiceTableViewCell
        cell.voiceLabel!.text = voice[indexPath.row]
    //這邊就是根據 day[indexPath.row] 的陣列內容印出鈴聲
    //這邊是利用 .accessoryType 的內建函式去幫有在被選擇到的天數印上打勾的樣式，在單例陣列裡的會被打勾，沒有的話就不會印出
        if selectVoice == voice[indexPath.row] {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectVoice = voice[indexPath.row]
        voiceValue.shared.select = voice[indexPath.row]
        tableView.reloadData()
    }
}
    

