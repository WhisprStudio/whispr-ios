//
//  test.swift
//  Whispr
//
//  Created by Victor maurin on 07/11/2021.
//
import CoreBluetooth
import SwiftUI

/// This View is showing all the devices looking for connection.
///
/// Show if Bluetooth is working on the phone
///
/// Show which device is connected
struct DeviceList: View {
    @ObservedObject var bleManager = BLEManager()
    init() {
        
    }
    var body: some View {
        VStack (spacing: 10) {

            Text("Bluetooth Devices")
                .font(.largeTitle)
                .frame(maxWidth: .infinity, alignment: .center)
            List(bleManager.peripherals) { peripheral in
                HStack {
                    Button(action: {
                        self.bleManager.connectToDevice(peripheral: peripheral.peripheral)
                    }) {
                        Text(peripheral.name)
                    }
                }
            }.frame(height: 300)

            Spacer()

            Text("STATUS")
                .font(.headline)

            // Status goes here
            if bleManager.isSwitchedOn {
                Text("Bluetooth is switched on")
                    .foregroundColor(.green)
            }
            else {
                Text("Bluetooth is NOT switched on")
                    .foregroundColor(.red)
            }

            Spacer()

            HStack {
                VStack (spacing: 10) {
                    Button(action: {
                        self.bleManager.startScanning()
                    }) {
                        Text("Start Scanning")
                    }
                    Button(action: {
                        self.bleManager.stopScanning()
                    }) {
                        Text("Stop Scanning")
                    }
                }.padding()
            }
            Spacer()
            
            if bleManager.myPeripheral != nil {
                Text("Connecté à")
                Text(bleManager.myPeripheral?.name ?? "")
                Button(action : {
                    self.bleManager.disconnectToDevice()
                }) {
                    Text("Se déconencter")
                }
            }
        }
    }
}

struct DeviceList_Previews: PreviewProvider {
    static var previews: some View {
        DeviceList()
    }
}
