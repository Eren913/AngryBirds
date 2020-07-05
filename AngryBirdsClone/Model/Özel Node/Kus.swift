//
//  Kus.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 24.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import Foundation
import SpriteKit
enum KusTipi : String {
    case Gri
    case Mavi
    case Sari
    case Kirmizi
}

class Kus : SKSpriteNode {
    
    let kusTipi : KusTipi
    var secildiMi : Bool = false
    var ucuyorMu : Bool = false {
        didSet {
            if ucuyorMu {
                physicsBody?.isDynamic = true
                ucusAnimasyonu(aktif: true)
            } else {
                ucusAnimasyonu(aktif: false)
            }
        }
    }
    
    let ucusKareleri : [SKTexture]
    init(kusTipi : KusTipi) {
        self.kusTipi = kusTipi
        ucusKareleri = AnimasyonAyarlari.yukleTexture(atlas: SKTextureAtlas(named: kusTipi.rawValue), adi: kusTipi.rawValue)
        let texture = SKTexture(imageNamed: kusTipi.rawValue+"1")
        super.init(texture: texture, color: .clear, size: texture.size())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(" Hata")
    }
    
    func ucusAnimasyonu(aktif : Bool) {
        if aktif {
            
            run(SKAction.repeatForever(SKAction.animate(with: ucusKareleri, timePerFrame: 0.1, resize: true, restore: true)))
        } else {
            removeAllActions()
        }
    }
    
}
