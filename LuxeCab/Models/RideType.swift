//
//  RideType.swift
//  LuxeCab
//
//  Created by JJMac on 16/06/24.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable{
    case luxeCabS
    case luxeCabX
    case luxeCabXL
    
    var id: Int {return rawValue}
    
    var description: String{
        switch self{
        case .luxeCabS: return "LuxeAuto S"
        case .luxeCabX: return "LuxeCab X"
        case .luxeCabXL: return "LuxeCab XL"
        }
    }
    
    var imageName: String{
        switch self{
        case .luxeCabS: return "luxAuto-s"
        case .luxeCabX: return "uber-x"
        case .luxeCabXL: return "uber-black"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .luxeCabS:
            return 30
        case .luxeCabX:
            return 50
        case .luxeCabXL:
            return 90
        }
    }
    
    func computePrice(for distanceInMeters: Double) -> Double {
        let distanceInMiles =  distanceInMeters / 1600
        
        switch self {
        case .luxeCabS:
            return distanceInMiles * 1.2 * baseFare
        case .luxeCabX:
            return distanceInMiles * 1.5 * baseFare
        case .luxeCabXL:
            return distanceInMiles * 2.0 * baseFare
        }
    }
}
