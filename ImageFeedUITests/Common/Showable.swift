//
//  Showable.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import XCTest

protocol Showable {
    func isShowing() -> Bool
    func waitForShowing()
    func waitForShowing(for timeout: TimeInterval)

}

extension Showable {
    func waitForShowing() {
        XCTContext.runActivity(named: "Ожидание Showable \(self)") { _ in
            waitForShowing(for: 9)
        }
    }

    func waitForShowing(for timeoutValue: Double = 60) {
        XCTContext.runActivity(named: "Ожидание Showable \(self), timeout = \(timeoutValue)") { _ in
            CommonWaiter.waitFor(condition: { self.isShowing() }, timeout: timeoutValue, message: "Ожидание \(type(of: self))")
        }
    }
}
