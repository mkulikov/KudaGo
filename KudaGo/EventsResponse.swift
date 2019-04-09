//
//  EventsResponse.swift
//  KudaGo
//
//  Created by mikhail.kulikov on 01/04/2019.
//  Copyright © 2019 mikhail.kulikov. All rights reserved.
//

import Foundation

struct EventsResponse: Decodable {
    let results: [Event]
    let count: Int?
}

struct Event: Decodable {
    let title: String?
}
