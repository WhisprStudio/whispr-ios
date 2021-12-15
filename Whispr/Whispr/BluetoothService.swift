//
//  BluetoothService.swift
//  Whispr
//
//  Created by Victor maurin on 15/12/2021.
//

import CoreBluetooth
 
class BluetoothService: NSObject { // 1.
    
    // 2.
    let dataServiceUuid = "180A"
    let dataCharacteristicUuid = "2A29"
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var dataCharacteristic: CBCharacteristic?
    var bluetoothState: CBManagerState {
        return self.centralManager.state
    }
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        self.peripheral = nil
        guard self.centralManager.state == .poweredOn else { return }
 
        self.centralManager.scanForPeripherals(withServices: [])
        print("scan started")
    }
    
    func stopScan() {
        self.centralManager.stopScan()
        print("scan stopped\n")
    }
    
    func connect() {
        guard self.centralManager.state == .poweredOn else { return }
        guard let peripheral = self.peripheral else { return }
        self.centralManager.connect(peripheral)
    }
    
    func disconnect() {
        guard let peripheral = self.peripheral else { return }
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}
