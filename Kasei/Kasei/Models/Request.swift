//
//  Request.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import Foundation

struct Request: Codable {
    var senderID: String
    var status: String?
    var delSlotStart: Date?
    var items: Array<RequestItem>
}
