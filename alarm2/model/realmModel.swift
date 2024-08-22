//
//  File.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/14.
//

import Foundation
import RealmSwift
import UIKit

class alarm: Object {
    //自動生成ＵＵＩＤ
    @objc dynamic var uuid: String = UUID().uuidString
    @objc dynamic var morning: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var repeaT: String = ""
    @objc dynamic var message: String = ""
        
    //設定索引主題
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience init(morning: String, time: Date, repeaT: String, message: String) {
       self.init()
        self.morning = morning
       self.time = time
       self.repeaT = repeaT
        self.message = message
        
   }
}
