//
//  Formatter.swift
//  CovidCLI
//
//  Created by Mikael Konradsson on 2020-04-13.
//  Copyright © 2020 Mikael Konradsson. All rights reserved.
//

import Foundation
import Table

struct Formatter {

    private static func increased(previous: Int?, current: Int) -> String {
        guard let previous = previous else {
            return "\(current)"
        }

        let newValue = current - previous
        if newValue > 0 {
            return "\(current) +(\(newValue))"
        } else if newValue < 0 {
            return " \(current) -(\(abs(newValue))"
        }
        return "\(current)"
    }

    static func printHistory(result: RequestResult<History>) {

        let historyDictionary = result.result
        let keys = historyDictionary.keys.sorted()

        var previous: History?

        var rows: [[String]] = [["Datum", "Bekräftade (+/-)", "Döda (+/-)", "Friska (+/-)"]]

        keys.forEach { key in
            if let history = historyDictionary[key] {
                let date = "\(key)"

                let confirmed = Formatter.increased(
                    previous: previous?.confirmed,
                    current: history.confirmed
                )

                let death = Formatter.increased(
                    previous: previous?.deaths,
                    current: history.deaths
                )

                let recovered = Formatter.increased(
                    previous: previous?.recovered,
                    current: history.recovered
                )

                rows.insert([date, confirmed, death, recovered], at: 1)
                previous = history
            }
        }

        do {
            let table = try Table(data: rows).table()
            print(table)
        } catch {
            print(error)
        }
    }
}
