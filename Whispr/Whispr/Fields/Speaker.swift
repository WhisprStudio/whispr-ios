//
//  Speaker.swift
//  Whispr
//
//  Created by Paul Erny on 04/12/2021.
//

import Foundation

class Speaker: Identifiable, Codable {
    
    init(name: String = "", volume: Double = 50, noiseCanceling: Double = 50) {
        self.name = name
        self.volume = volume
        self.noiseCanceling = noiseCanceling
    }
    
    var id = UUID()
    var name: String = ""
    var type: String = "portable2"
    var volume: Double = 50.0
    var noiseCanceling: Double = 50.0
    //TODO: Add bluetooth datas
    var configs: [SpeakerConfig] = [] // switch from @Published to @StateObject ?
    
}

class ContentManager: ObservableObject {
    @Published private(set) var speakers: [Speaker]
    static let speakersKey = "speakersData"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.speakersKey) {
            if let decoded = try? JSONDecoder().decode([Speaker].self, from: data) {
                self.speakers = decoded
                return
            }
        }
        speakers = []
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(speakers) {
            UserDefaults.standard.set(encoded, forKey: Self.speakersKey)
        }
    }

    // add a speaker
    func add(_ speaker: Speaker) {
        speakers.append(speaker)
        save()
    }
    
    // add a config to a speaker
    func add(config: SpeakerConfig, speakerId: UUID) {
        speakers.first(where: {
                        $0.id == speakerId
                       }
        )?.configs.append(config)
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    // deletes a speaker
    func delete(id speaker: UUID) {
        speakers.removeAll(where: {
            $0.id == speaker
        })
        save()
    }
    
    // remove a config from a speaker
    func delete(configId: UUID, speakerId: UUID) {
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.removeAll(where: {
            $0.id == configId
        })
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
}
