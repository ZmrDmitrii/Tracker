//
//  TrackerCellDelegate.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 16/12/24.
//

import Foundation

protocol TrackerCellDelegate: AnyObject {
    func didTapTrackerCompletedButton(for cell: TrackerCell)
    func addTrackerRecord(for cell: TrackerCell)
    func removeTrackerRecord(for cell: TrackerCell)
}
