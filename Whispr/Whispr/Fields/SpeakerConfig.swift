//
//  SpeakerConfig.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import Foundation

class SpeakerConfig: Identifiable, Codable {

    init(name: String = "",
         volume: Double = 50,
         noiseCanceling: Double = 50,
         hasTimeTrigger: Bool = false,
         startTime: Date = Calendar.autoupdatingCurrent.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
         endTime: Date = Calendar.autoupdatingCurrent.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    ) {
        self.name = name
        self.volume = volume
        self.noiseCanceling = noiseCanceling
        self.hasTimeTrigger = hasTimeTrigger
        self.startTime = startTime
        self.endTime = endTime
    }
    
    var id = UUID()
    var name: String = ""
    var volume: Double = 50.0
    var noiseCanceling: Double = 50.0
    var hasTimeTrigger: Bool = false
    var startTime: Date = Calendar.autoupdatingCurrent.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!
    var endTime: Date = Calendar.autoupdatingCurrent.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
}
