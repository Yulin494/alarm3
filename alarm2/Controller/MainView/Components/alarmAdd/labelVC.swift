//
//  labelVC.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/16.
//

import UIKit

class labelVC: UIViewController, UITextFieldDelegate {
    // MARk: - IBOutlet
    @IBOutlet var messageTextfield: UITextField!
    
    // MARK: - Proprtty
    var delegate: MessageDelegate?
    var inputText: String?
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextfield.keyboardType = .default
        messageTextfield.placeholder = "鬧鐘"
        messageTextfield.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 在視圖出現時，設置 text field 成為第一響應者
        self.messageTextfield.becomeFirstResponder()
        }
    // MARK: - UI Setting
    
    // MARK: - IBAction
    @IBAction func inputText(_ sender: Any) {
        inputText = messageTextfield.text
        print(inputText ?? "")
    }
    
    // MARK: - Function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 結束編輯 把鍵盤隱藏起來
        self.view.endEditing(true)
        return true
    }
}
// MARK: - Extensions
protocol MessageDelegate {
    func didSendMessage(_ message: String)
}
