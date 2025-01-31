//
//  CellGeometricParameters.swift
//  Tracker
//
//  Created by Дмитрий Замараев on 11/12/24.
//

import Foundation

struct CollectionGeometricParameters {
    
    let numberOfCells: Int
    let rightInset: CGFloat
    let leftInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(
        numberOfCells: Int,
        rightInset: CGFloat,
        leftInset: CGFloat,
        cellSpacing: CGFloat
    ) {
        self.numberOfCells = numberOfCells
        self.rightInset = rightInset
        self.leftInset = leftInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = rightInset + leftInset + CGFloat(numberOfCells - 1) * cellSpacing
    }
}
