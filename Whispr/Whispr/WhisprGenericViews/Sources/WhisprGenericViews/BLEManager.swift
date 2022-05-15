//
//  BLEManager.swift
//  Whispr
//
//  Created by Victor maurin on 08/11/2021.
//
import Foundation
import CoreBluetooth
import os
import AVFAudio

///
/// Bluetooth manager
/// Function for scanning, connect and disconnect to bluetooth peripheral
///
///

struct Peripheral: Identifiable {
    let id: Int
    let name: String
    let rssi: Int
    let peripheral: CBPeripheral
}

struct cbPeripheral: Identifiable {
    let id: Int
    let periphiral: CBPeripheral
}

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        }
        else {
            isSwitchedOn = false
        }
    }
    private let serviceUUID = CBUUID(string: "C0F6F394-FDE3-46F6-827C-104034304184")
        
    private let inputCharUUID = CBUUID(string: "214A8DD4-04CF-48E5-BB1D-F6018E28D7A2")
    private var inputChar: CBCharacteristic?
    private let outputCharUUID = CBUUID(string: "643954A4-A6CC-455C-825C-499190CE7DB0")
    private var outputChar: CBCharacteristic?
    var id = UUID()
    var myCentral: CBCentralManager!
    var mychar :CBCharacteristic!
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var cbperipherals = [cbPeripheral]()
    @Published var myPeripheral: CBPeripheral!
    private var txCharacteristic: CBCharacteristic!
    private var rxCharacteristic: CBCharacteristic!
    private var sound: [UInt8] = [20]
    
    override init() {
        super.init()
        

        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
       
        peripheralName = peripheral.name
        if peripheralName != nil {
            if !peripherals.contains(where: { $0.name == peripheralName }) {
                let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, peripheral: peripheral)
                peripherals.append(newPeripheral)
            }
            
        }
    }
    
    func connectToDevice(peripheral: CBPeripheral) {
        self.myPeripheral = peripheral
        self.myPeripheral.delegate = self
        self.myCentral.connect(peripheral, options: nil)
        print("CONNECTED TO \(String(describing: self.myPeripheral.name))")
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "UNKNOWN")")
        myPeripheral.delegate = self
        myPeripheral.discoverServices(nil)
    }
    
    func disconnectToDevice() {
        if (self.myPeripheral != nil) {
            self.myCentral.cancelPeripheralConnection(self.myPeripheral)
            self.myPeripheral = nil
            print("DISCONNECTED TO DEVICE")
        }
    }
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
    func send(volume: UInt8) {
        print("send value")
        guard let peripheral = myPeripheral,
              let inputChar = inputChar else {
            return
        }
        print("ca passe la")
        print("volume \(AVAudioSession.sharedInstance().outputVolume)")
        sound[0] = UInt8(AVAudioSession.sharedInstance().outputVolume)
        myPeripheral.writeValue(Data(sound), for: inputChar, type: .withoutResponse)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
                return
        }
            
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered characteristics for \(myPeripheral.name ?? "UNKNOWN")")
        
        guard let characteristics = service.characteristics else {
            return
        }
        
        for ch in characteristics {
            switch ch.uuid {
                case inputCharUUID:
                    inputChar = ch
                case outputCharUUID:
                    outputChar = ch
                    // subscribe to notification events for the output characteristic
                    myPeripheral.setNotifyValue(true, for: ch)
                default:
                    break
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("Notification state changed to \(characteristic.isNotifying)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

         var characteristicASCIIValue = NSString()

         guard characteristic == rxCharacteristic,

         let characteristicValue = characteristic.value,
         let ASCIIstring = NSString(data: characteristicValue, encoding: String.Encoding.utf8.rawValue) else { return }

         characteristicASCIIValue = ASCIIstring

         print("Value Recieved: \((characteristicASCIIValue as String))")
    }
    
    func writeOutgoingValue(data: String){
          
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        
        if let bluefruitPeripheral = self.myPeripheral {
              
          if let txCharacteristic = txCharacteristic {
                  
            bluefruitPeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
              }
          }
      }
    
}
