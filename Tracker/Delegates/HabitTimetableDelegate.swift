//
//  HabitTimetableDelegate.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 19/12/24.
//

import Foundation

protocol HabitTimetableDelegate: AnyObject {
    func updateTimetableButton(with timetable: Set<WeekDay>)
}
