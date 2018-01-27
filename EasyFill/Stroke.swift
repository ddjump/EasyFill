//
//  Stroke.swift
//  EasyFill
//
//  Created by Daniel Yen on 1/27/18.
//  Copyright © 2018 Daniel Yen. All rights reserved.
//

import UIKit

struct Stroke {
    let start: CGPoint
    let end: CGPoint
   
    init(start s: CGPoint, end e: CGPoint) {
        start = s
        end = e
    }
}
