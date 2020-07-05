//
//  GameViewController.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 12.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gosterMenuSahnesi()
    }

    
}

protocol  SahneYoneticiDelegate {
    
    func gosterOyunSahnesi(level : Int)
    func gosterMenuSahnesi()
    func gosterLevelSahnesi()
}

extension GameViewController : SahneYoneticiDelegate {
    
    func gosterOyunSahnesi(level: Int) {
        let sahneAdi = "GameScene\(level)"
        if let oyunSahnesi = SKScene(fileNamed: sahneAdi) as? GameScene {
            oyunSahnesi.sahneYoneticiDelegate = self
            oyunSahnesi.levelSayi = level
            goster(sahne: oyunSahnesi)
        }
        
    }
    
    func gosterMenuSahnesi() {
        let menu = MenuScene()
        menu.sahneYoneticiDelegate = self
        goster(sahne: menu)
    }
    
    func gosterLevelSahnesi() {
        print("Çalıştı")
        let level = LevelScene()
        level.sahneYoneticiDelegate = self
        goster(sahne: level)
    }
    
    func goster(sahne : SKScene) {
        
        if let view = self.view as! SKView? {
            
            if let grDizi = view.gestureRecognizers {
                for gr in grDizi {
                    view.removeGestureRecognizer(gr)
                }
            }
            
            sahne.scaleMode = .resizeFill
            view.presentScene(sahne)
            view.ignoresSiblingOrder = true
        }
        
    }
    
    
    
}



