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
}

struct Event: Decodable {
    let title: String?
}
