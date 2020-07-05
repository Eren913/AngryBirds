//
//  Ayarlar.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 25.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import UIKit


struct ZPozisyon {
    static let arkaPlan : CGFloat = 0
    static let engeller : CGFloat = 1
    static let kus : CGFloat = 3
    static let oyunDisiArkaPlan : CGFloat = 10
    static let labelMenu : CGFloat = 11
    
}


struct FizikKategorileri {
    static let bos : UInt32 = 0
    static let altin : UInt32 = 0
    static let tumu : UInt32 = .max
    static let kenar : UInt32 = 0x1
    static let kus : UInt32 = 0x1 << 1
    static let blok : UInt32 = 0x1 << 2
    static let dusman : UInt32 = 0x1 << 3
    
    
}


enum OyunDurumu {
    case Hazir
    case Ucuyor
    case Bitis
    case Dirilme
    case OyunBitti
}


struct Leveller {
    static var levellerSozluk = [String:Any]()
}
