//
//  WeekDayCellDelegate.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 19/12/24.
//

import Foundation

protocol WeekDayCellDelegate: AnyObject {
    func addDayToTimetable(for cell: WeekDayCell)
    func removeDayFromTimetable(for cell: WeekDayCell)
}
