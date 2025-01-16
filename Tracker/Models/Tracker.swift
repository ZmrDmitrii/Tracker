//
//  Tracker.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 6/12/24.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let timetable: Set<abbreviatedWeekDay>
}
