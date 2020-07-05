//
//  Altin.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 29.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit

enum AltinTipi : String {
    case Altin1
    case Altin2
}


class Altin : SKSpriteNode {
    
    let tipi : AltinTipi
    let degeri : Int
    
    init(tipi : AltinTipi) {
        
        self.tipi = tipi
        
        switch tipi {
        case .Altin1 :
            degeri = 20
            break
        case .Altin2 :
            degeri = 10
            break
        default :
            break
        }
        
        let texture = SKTexture(imageNamed: tipi.rawValue)
        super.init(texture: texture, color: .clear, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bodyOlustur() {
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.isDynamic = false
        
        physicsBody?.categoryBitMask = FizikKategorileri.altin
        physicsBody?.contactTestBitMask = FizikKategorileri.tumu
        physicsBody?.collisionBitMask = FizikKategorileri.bos
    }
    
    func carpisma() -> Int {
        removeFromParent()
        return degeri
    }
    
}
