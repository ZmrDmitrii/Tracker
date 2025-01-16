//
//  File.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 13/1/25.
//

import Foundation

protocol CreateHabitViewControllerDelegate: AnyObject {
    func addTracker(_ tracker: Tracker, to categoryName: String)
}
