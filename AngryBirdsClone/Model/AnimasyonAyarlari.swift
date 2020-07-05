//
//  AnimasyonAyarlari.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 28.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit


class AnimasyonAyarlari {
    
    static func yukleTexture(atlas : SKTextureAtlas, adi : String) -> [SKTexture] {
        
        var textures = [SKTexture]()
        
        for i in 1...atlas.textureNames.count {
            let textureAdi = adi + String(i)
            textures.append(atlas.textureNamed(textureAdi))
        }
        
        return textures
        
    }
    
}
