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
///
///

struct DeviceList: View {
    @ObservedObject var bleManager = BLEManager()
    init() {
        
    }
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {

            Text("Bluetooth Devices")
                .frame(maxWidth: .infinity, alignment: .center)
                .primaryFont(size: .XL, weight: .semiBold)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(bleManager.peripherals, id: \.id) { peripheral in
                        Button(peripheral.name) {
                            if bleManager.myPeripheral == nil {
                                self.bleManager.connectToDevice(peripheral: peripheral.peripheral)
                            }
                        }
                        .primaryFont(size: .S, weight: .regular)
                    }
                }
            }

            HStack {
                Button("Start Scanning") {
                    self.bleManager.startScanning()
                }
                .buttonStyle(FilledButton())
                Button("Stop Scanning") {
                    self.bleManager.stopScanning()
                }
                .buttonStyle(FilledButton())
            }
            Spacer()
            
            if bleManager.myPeripheral != nil {
                VStack (alignment: .leading, spacing: 16) {
                    Button("Envoyer de la donnée") {
                        self.bleManager.send(volume: 0x10)
                    }
                    Text("Connecté à : ")
                        .primaryFont(size: .M, weight: .regular)
                    Text(bleManager.myPeripheral?.name ?? "")
                        .primaryFont(size: .L, weight: .thin)
                }
                Button("Se déconnecter") {
                    self.bleManager.disconnectToDevice()
                }
                .buttonStyle(OutlineButton())
            }
        }
    }
}

struct DeviceList_Previews: PreviewProvider {
    static var previews: some View {
        DeviceList()
    }
}
