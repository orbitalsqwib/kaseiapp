//
//  StatusMap.swift
//  Kasei
//
//  Created by Eugene L. on 19/1/21.
//

import Foundation

struct StatusMap {
    static let statusMap = [
        "done": "Completed!",
        "otw": "Delivering...",
        "prep": "Preparing...",
        "sent": "Request Sent"
    ]
    
    static func getStatus(for code: String) -> String {
        return NSLocalizedString(statusMap[code]!, comment: "")
    }
}
