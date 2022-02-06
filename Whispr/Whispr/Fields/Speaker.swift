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
    
    enum Property {
        case name,
             type,
             volume,
             noiseCanceling
    }
    
    enum ConfigProperty {
        case name,
             volume,
             noiseCanceling,
             timeTrigger,
             startTime,
             endTime
    }

    private var saveProperty = [Property: (String, UUID)->Void]()
    private var saveConfigProperty = [ConfigProperty: (String, UUID, UUID)->Void]()

    init() {
        speakers = []

        saveProperty.updateValue(saveName, forKey: .name)
        saveProperty.updateValue(saveVolume, forKey: .volume)
        saveProperty.updateValue(saveNoiseCanceling, forKey: .noiseCanceling)

        saveConfigProperty.updateValue(saveConfigName, forKey: .name)
        saveConfigProperty.updateValue(saveConfigVolume, forKey: .volume)
        saveConfigProperty.updateValue(saveConfigNoiseCanceling, forKey: .noiseCanceling)
        saveConfigProperty.updateValue(saveTimeTriggerSwitch, forKey: .timeTrigger)
        saveConfigProperty.updateValue(saveStartTime, forKey: .startTime)
        saveConfigProperty.updateValue(saveEndTime, forKey: .endTime)
        if let data = UserDefaults.standard.data(forKey: Self.speakersKey) {
            if let decoded = try? JSONDecoder().decode([Speaker].self, from: data) {
                self.speakers = decoded
                return
            }
        }
    }
    
    private func saveName(value: String, speakerId: UUID) {
        speakers.first(where: {
            $0.id == speakerId
        })?.name = value
        save()
    }
    
    private func saveVolume(value: String, speakerId: UUID) {
        guard let volume = Double(value) else {
            print("error: couldn't convert \(value) to double (Speaker.swift)")
            return
        }
        speakers.first(where: {
            $0.id == speakerId
        })?.volume = volume
        save()
    }
    
    private func saveNoiseCanceling(value: String, speakerId: UUID) {
        guard let noiseCanceling = Double(value) else {
            print("error: couldn't convert \(value) to double (Speaker.swift)")
            return
        }
        speakers.first(where: {
            $0.id == speakerId
        })?.noiseCanceling = noiseCanceling
        save()
    }
    
    // save object property to Speaker class
    func save(property: Property, value: String, speakerId: UUID) {
        saveProperty[property]!(value, speakerId)
    }
    
    private func saveConfigName(value: String, speakerId: UUID, configId: UUID) {
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.first(where: {
            $0.id == configId
        })?.name = value
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    private func saveConfigVolume(value: String, speakerId: UUID, configId: UUID) {
        guard let volume = Double(value) else {
            print("error: couldn't convert \(value) to double (Speaker.swift)")
            return
        }
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.first(where: {
            $0.id == configId
        })?.volume = volume
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    private func saveConfigNoiseCanceling(value: String, speakerId: UUID, configId: UUID) {
        guard let noiseCanceling = Double(value) else {
            print("error: couldn't convert \(value) to double (Speaker.swift)")
            return
        }
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.first(where: {
            $0.id == configId
        })?.noiseCanceling = noiseCanceling
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    private func saveTimeTriggerSwitch(value: String, speakerId: UUID, configId: UUID) {
        guard value == "true" || value == "false" else {
            print("error: expected true of false but got \(value) (Speaker.swift)")
            return
        }
        let hasTimeTrigger = value == "true" ? true : false
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.first(where: {
            $0.id == configId
        })?.hasTimeTrigger = hasTimeTrigger
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    private func saveStartTime(value: String, speakerId: UUID, configId: UUID) {
        guard let timeSinceEpoch = Double(value) else {
            print("error: couldn't convert \(value) to double (time since epoch) (Speaker.swift)")
            return
        }
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.first(where: {
            $0.id == configId
        })?.startTime = Date(timeIntervalSince1970: timeSinceEpoch)
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    private func saveEndTime(value: String, speakerId: UUID, configId: UUID) {
        guard let timeSinceEpoch = Double(value) else {
            print("error: couldn't convert \(value) to double (time since epoch) (Speaker.swift)")
            return
        }
        speakers.first(where: {
            $0.id == speakerId
        })?.configs.first(where: {
            $0.id == configId
        })?.endTime = Date(timeIntervalSince1970: timeSinceEpoch)
        save()
        // need to manually trigger the observedObject since Speaker.configs cannot be of type @Published
        objectWillChange.send()
    }
    
    // save object property to Speaker class
    func saveConfig(property: ConfigProperty, value: String, speakerId: UUID, configId: UUID) {
        saveConfigProperty[property]!(value, speakerId, configId)
    }

    // save object array in cache
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
