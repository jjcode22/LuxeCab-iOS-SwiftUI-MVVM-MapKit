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
        case .luxeCabS: return "LuxeCab S"
        case .luxeCabX: return "LuxeCab X"
        case .luxeCabXL: return "LuxeCab XL"
        }
    }
    
    var imageName: String{
        switch self{
        case .luxeCabS: return "uber-x"
        case .luxeCabX: return "uber-black"
        case .luxeCabXL: return "uber-x"
        }
    }
}
