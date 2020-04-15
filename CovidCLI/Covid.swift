//
//  Covid.swift
//  CovidCLI
//
//  Created by Mikael Konradsson on 2020-04-14.
//  Copyright © 2020 Mikael Konradsson. All rights reserved.
//

import Foundation
import LineNoise

class Covid {

    private enum MenuChoice: Int {
        case country = 1
        case world
        case exit
    }

    private let network = Network()
    private let ln = LineNoise()

    private func readCountry() {
        do {
            print("\nEnter country abbrevation:")
            let input = try ln.getLine(prompt: "> ")
            print("Showing result for: \(input)\n")
            request(type: .history(country: .code(input)))
        } catch {
            print(error)
        }
    }

    private func runSelection(meny: Int?) {
        guard let item = meny, let meny = MenuChoice(rawValue: item) else {
            print("Not a valid input")
            start()
            return
        }

        switch meny {
        case .country:
            readCountry()
        case .world:
            print("Showing world statistics\n")
            request(type: .history(country: .world))
        case .exit:
            exit(0)
        }
    }

    func start() {
        print("Show statistics from a specific country or world statistics")
        print("1. Select Country")
        print("2. Show world statistics")
        print("3. Exit")

        do {
            let input = try ln.getLine(prompt: "> ")
            print()
            runSelection(meny: Int(input))
        } catch {
            print(error)
        }
    }

    func request(type: RequestType) {
        network.run(type: type) { (result: Result<RequestResult<History>, Error>) in
            switch result {
            case let .success(result):
                Formatter.printHistory(result: result)
            case let .failure(error):
                print(error)
            }
            self.start()
        }
        RunLoop.main.run()
    }
}
