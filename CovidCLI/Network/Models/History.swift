//
//  History.swift
//  CovidCLI
//
//  Created by Mikael Konradsson on 2020-04-13.
//  Copyright © 2020 Mikael Konradsson. All rights reserved.
//

import Foundation

struct History: Codable {
    let confirmed: Int
    let deaths: Int
    let recovered: Int
}
