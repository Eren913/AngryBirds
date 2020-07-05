//
//  MenuScene.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 27.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit

class MenuScene : SKScene {
    var sahneYoneticiDelegate : SahneYoneticiDelegate?
    
    override func didMove(to view: SKView) {
        menuGoster()
    }
    
    func menuGoster() {
        
        
        
        let menuArkaPlan = SKSpriteNode(imageNamed: "menuArkaPlan")
        menuArkaPlan.position = CGPoint(x: frame.midX, y: frame.midY)
        menuArkaPlan.olceklendir(boyut: frame.size, genislik: true, oran: 1.0)
        menuArkaPlan.zPosition = ZPozisyon.arkaPlan
        addChild(menuArkaPlan)
        
        
        let btnOynat = SKButton(varsayilanButonAdi: "oynatButonu", calistir: levelSahnesineGit, index: 0)
        
        btnOynat.position = CGPoint(x: frame.midX, y: frame.midY)
        btnOynat.zPosition = ZPozisyon.labelMenu
        btnOynat.olceklendir(boyut: frame.size, genislik: false, oran: 0.3)
        addChild(btnOynat)
    }
    
    func levelSahnesineGit(_ : Int) {
        sahneYoneticiDelegate?.gosterLevelSahnesi()
    }
    
}
