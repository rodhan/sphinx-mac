//
//  TimeTracker.swift
//  Sphinx
//
//  Created by Rodhan Hickey on 19/02/2024.
//  Copyright © 2024 Sphinx. All rights reserved.
//

import Foundation
import os.signpost

@available(macOS 12.0, *)
class TimeTracker {
    static let shared = TimeTracker()
    
    private let pointsOfInterest = OSSignposter(subsystem: Bundle.main.bundleIdentifier!, category: .pointsOfInterest)
    private var signpostState: OSSignpostIntervalState?
    
    private var timers: [String: DispatchTime] = [:]
    
    private init() {}
    
    func startTimer(withLabel label: StaticString) {
        timers[label.description] = DispatchTime.now()
        
        let id = pointsOfInterest.makeSignpostID()
        signpostState = pointsOfInterest.beginInterval(label, id: id)
    }
    
    func stopTimer(withLabel label: StaticString) {
        if let signpostState {
            self.signpostState = nil
            pointsOfInterest.endInterval(label, signpostState)
        }
        
        guard let startTime = timers[label.description] else {
            print("🐞⏲️ Timer '\(label)' was not started.")
            return
        }
        
        let endTime = DispatchTime.now()
        let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        timers[label.description] = nil // Remove the timer
        
        print("🐞⏲️ Time taken for '\(label)': \(timeInterval) seconds")
    }
}
