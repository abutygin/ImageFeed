//
//  ConditionWaiter.swift
//  ImageFeedUITests
//
//  Created by ALEXANDER BUTYGIN on 06.05.2026.
//

import XCTest

enum ConditionWaiter {
    static func waitFor(condition: () throws -> Bool, timeout seconds: TimeInterval, fail: Bool = true, message: String = "") {
        let startTime = Date()
        print("waitFor startTime = \(startTime)")
        var currentTime = Date()
        while currentTime.timeIntervalSince(startTime) < seconds {
            do {
                let ready = try condition()
                if ready {
                    return
                }
            } catch {
                print("waitFor(condition: Error info: \(error)")
            }
            currentTime = Date()
        }
        if fail {
            XCTFail("Cannot wait condition  during \(seconds) secs. \(message)")
        }
        print("waitFor endTime = \(Date())")
    }
}
