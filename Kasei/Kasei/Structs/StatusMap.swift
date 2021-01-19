//
//  StatusMap.swift
//  Kasei
//
//  Created by Eugene L. on 19/1/21.
//

import Foundation

struct StatusMap {
    static let statusMap = [
        "done_en": "Completed!",
        "done_zh": "已完成!",
        "otw_en": "Delivering...",
        "otw_zh": "正在运送...",
        "prep_en": "Preparing...",
        "prep_zh": "正在准备...",
        "sent_en": "Request Sent",
        "sent_zh": "请求已发送"
    ]
    
    static func getStatus(for code: String) -> String {
        if let lang = Locale.current.languageCode, let translated = statusMap["\(code)_\(lang)"] {
            return translated
        } else {
            print("Translation failed for status")
            return ""
        }
    }
}
