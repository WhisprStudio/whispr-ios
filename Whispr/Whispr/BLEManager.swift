//
//  BLEManager.swift
//  Whispr
//
//  Created by Victor maurin on 08/11/2021.
//
import Foundation
import CoreBluetooth

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
    
    var myCentral: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var peripherals = [Peripheral]()
    @Published var cbperipherals = [cbPeripheral]()
    @Published var myPeripheral: CBPeripheral!
    
    override init() {
        super.init()
        

        myCentral = CBCentralManager(delegate: self, queue: nil)
        myCentral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        var peripheralName: String!
       
        peripheralName = peripheral.name
        if peripheralName != nil {
            let newPeripheral = Peripheral(id: peripherals.count, name: peripheralName, rssi: RSSI.intValue, peripheral: peripheral)
            print(newPeripheral)
            peripherals.append(newPeripheral)
        }
    }
    
    func connectToDevice(peripheral: CBPeripheral) {
        self.myPeripheral = peripheral
        self.myPeripheral.delegate = self
        self.myCentral.connect(peripheral, options: nil)
        print("CONNECTED TO \(String(describing: self.myPeripheral.name))")
    }
    
    func disconnectToDevice() {
        self.myCentral.cancelPeripheralConnection(self.myPeripheral)
        self.myPeripheral = nil
        print("DISCONNECTED TO DEVICE")
    }
    
    func startScanning() {
        print("startScanning")
        myCentral.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        print("stopScanning")
        myCentral.stopScan()
    }
    
}
