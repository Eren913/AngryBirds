//
//  SKButton.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 27.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit


class SKButton : SKSpriteNode {
    
    
    var btnVarsayilan : SKSpriteNode
    var calistir : (Int) -> ()
    var index : Int
    
    
    init(varsayilanButonAdi : String, calistir : @escaping(Int) -> (), index : Int) {
        
        btnVarsayilan = SKSpriteNode(imageNamed: varsayilanButonAdi)
        self.calistir = calistir
        self.index = index
        
        
        super.init(texture: nil, color: .clear, size: btnVarsayilan.size)
        isUserInteractionEnabled = true
        addChild(btnVarsayilan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        btnVarsayilan.alpha = 0.65
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first! as UITouch
        let konum = touch.location(in: self)
        if btnVarsayilan.contains(konum) {
            calistir(index)
        }
        btnVarsayilan.alpha = 1.0
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        btnVarsayilan.alpha = 1.0
    }
}
