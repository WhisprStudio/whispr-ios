//
//  SpeakerConfig.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import Foundation

class SpeakerConfig: Identifiable, Codable {

    init(name: String = "", volume: Double = 50, noiseCanceling: Double = 50) {
        self.name = name
        self.volume = volume
        self.noiseCanceling = noiseCanceling
    }
    
    var id = UUID()
    var name = ""
    var volume = 50.0
    var noiseCanceling = 50.0
    var hasTimeTrigger = false
    //TODO: Store activation/deactivation hours
}
