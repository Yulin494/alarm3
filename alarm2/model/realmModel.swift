//
//  File.swift
//  alarm2
//
//  Created by imac-1681 on 2024/8/14.
//

import Foundation
import RealmSwift
import UIKit

class alarm3: Object {
    //自動生成ＵＵＩＤ
    @Persisted var uuid: String = UUID().uuidString
    @Persisted var morning: String = ""
    @Persisted var time: Date = Date()
    @Persisted var repeaT: String = ""
    @Persisted var message: String = ""
    @Persisted var reminder: Bool = false
    @Persisted var isEnabled: Bool = true  // 新增的屬性

    //設定索引主題
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    convenience init(morning: String,
                     time: Date,
                     repeaT: String,
                     message: String,
                     reminder: Bool) {
        self.init()
        self.morning = morning
        self.time = time
        self.repeaT = repeaT
        self.message = message
        self.reminder = reminder
    }
}
