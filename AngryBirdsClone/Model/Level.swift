//
//  Level.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 28.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation


struct Level {
    
    let kuslar : [String]
    
    init?(level : Int) {
        
        guard let levellerSozluk = Leveller.levellerSozluk["Level\(level)"] as? [String : Any]  else { return nil}
        
        guard let kuslar = levellerSozluk["Kuslar"] as? [String] else { return nil}
        self.kuslar = kuslar
    }
    
}
