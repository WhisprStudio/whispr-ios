//
//  Connection.swift
//  Whispr
//
//  Created by Victor maurin on 15/12/2021.
//

import Foundation
import CoreBluetooth
 
extension BluetoothService: CBCentralManagerDelegate {
    
    var expectedNamePrefix: String { return "WhisprSpeaker" }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("bluetooth is OFF (\(central.state.rawValue))")
            self.stopScan()
            self.disconnect()
        } else {
            print("bluetooth is ON")
            self.flowController?.bluetoothOn()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil && peripheral.name?.starts(with: self.expectedNamePrefix) ?? false else { return }
        print("discovered peripheral: \(peripheral.name!)")
        
        self.peripheral = peripheral
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if let periperalName = peripheral.name {
            print("connected to: \(periperalName)")
        } else {
            print("connected to peripheral")
        }
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("peripheral disconnected")
        self.dataCharacteristic = nil
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("failed to connect: \(error.debugDescription)")
        self.dataCharacteristic = nil
    }
}


