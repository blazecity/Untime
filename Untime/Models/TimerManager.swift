//
//  TimerManager.swift
//  TrackYourTime
//
//  Created by Jan Baumann on 06.12.21.
//

import Foundation
import SwiftUI

class TimerManager: ObservableObject {
    @Published var time: Int
    private var _seconds: Int
    private var seconds: Int {
        get {
            _seconds
        }
        set {
            formattedTime = TimerManager.formatTime(newValue: newValue)
            _seconds = newValue
        }
    }
    
    @Published var formattedTime: String
    var timer = Timer()
    
    convenience init() {
        self.init(time: 0)
    }
    
    init(time: Int) {
        self.time = time
        self._seconds = time
        self.formattedTime = "00:00:00"
        self.seconds = time
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.time += 1
            self.seconds += 1
        })
    }
    
    func interrupt() {
        timer.invalidate()
    }
    
    static func formatTime(newValue: Int) -> String {
        let intTime = newValue
        let (hours, minutes, seconds) = getHoursMinutesSeconds(seconds: intTime)
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    static func getHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        let hours = seconds / 3600
        let minutes = seconds / 60 % 60
        let seconds = seconds % 60
        return (hours, minutes, seconds)
    }
}
