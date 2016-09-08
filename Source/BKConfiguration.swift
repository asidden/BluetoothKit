//
//  BluetoothKit
//
//  Copyright (c) 2015 Rasmus Taulborg Hummelmose - https://github.com/rasmusth
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import CoreBluetooth

/**
    Class that represents a configuration used when starting a BKCentral object.
*/
public class BKConfiguration {
    
    // MARK: service scan strategy enum
    /// .All will scan for all peripherals
    /// .Sepcific will scan only for the ones with specific UUID
    public enum ServiceScanStrategy {
        case All
        case Specific([CBUUID])
    }

    // MARK: Properties

    /// The UUID for the service used to send data. This should be unique to your applications.
    public let dataServiceUUID: CBUUID

    /// The UUID for the characteristic used to send data. This should be unique to your application.
    public var dataServiceCharacteristicUUID: CBUUID

    /// Data used to indicate that no more data is coming when communicating.
    public var endOfDataMark: NSData

    /// Data used to indicate that a transfer was cancellen when communicating.
    public var dataCancelledMark: NSData

    internal let serviceScanStrategy: ServiceScanStrategy

    // MARK: Initialization

    public init(dataServiceUUID: NSUUID, dataServiceCharacteristicUUID: NSUUID, scanAll: Bool = false) {
        let serviceUUID = CBUUID(NSUUID: dataServiceUUID)
        self.dataServiceUUID = serviceUUID
        self.dataServiceCharacteristicUUID = CBUUID(NSUUID: dataServiceCharacteristicUUID)
        endOfDataMark = "EOD".dataUsingEncoding(NSUTF8StringEncoding)!
        dataCancelledMark = "COD".dataUsingEncoding(NSUTF8StringEncoding)!
        serviceScanStrategy = scanAll ? .All : .Specific([serviceUUID])
    }

    // MARK Functions

    internal func characteristicUUIDsForServiceUUID(serviceUUID: CBUUID) -> [CBUUID] {
        if serviceUUID == dataServiceUUID {
            return [ dataServiceCharacteristicUUID ]
        }
        return []
    }

}

internal extension BKConfiguration.ServiceScanStrategy {
    internal var asServiceUUIDs: [CBUUID]? {
        switch self {
        case .Specific(let uuids): return uuids
        case .All: return nil
        }
    }
}
