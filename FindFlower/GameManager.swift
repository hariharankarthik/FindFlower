//
//  GameManager.swift
//  WhatFlower
//
//  Created by Hari on 2019-08-26.
//  Copyright © 2019 Hariharan Karthikeyan. All rights reserved.
//

import Foundation

enum winStatus {
    case won
    case lost
    case notYet
}

class GameManager {
    
    static let sharedManager = GameManager()
    let connectionManager = ConnectionManager.sharedManager
}
