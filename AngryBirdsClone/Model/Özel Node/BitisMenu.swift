//
//  BitisMenu.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 29.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit


struct BitisMenuButonlari {
    static let menu = 1
    static let ileri = 2
    static let yenidenDene = 3
}



class BitisMenu : SKSpriteNode {
    
    let tipi : Int
    var menuButonDelegate : MenuButonDelegate?
    
    init(tipi: Int, boyut : CGSize) {
        
        self.tipi = tipi
        super.init(texture: nil, color: .clear, size: boyut)
        
        menuGoster()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func menuGoster() {
        
        let arkaPlan = tipi == 1 ? SKSpriteNode(imageNamed: "basarili") : SKSpriteNode(imageNamed: "basarisiz")
        arkaPlan.olceklendir(boyut: size, genislik: false, oran: 0.5)
        
        
        let btnMenu = SKButton(varsayilanButonAdi: "menu", calistir: butonYoneticisi, index: BitisMenuButonlari.menu)
        let btnIleri = SKButton(varsayilanButonAdi: "ileri", calistir: butonYoneticisi, index: BitisMenuButonlari.ileri)
        let btnYenidenDene = SKButton(varsayilanButonAdi: "yenidenDene", calistir: butonYoneticisi, index: BitisMenuButonlari.yenidenDene)
        
        btnIleri.isUserInteractionEnabled  = tipi == 1 ? true : false
        
        btnMenu.olceklendir(boyut: arkaPlan.size, genislik: true, oran: 0.2)
        btnIleri.olceklendir(boyut: arkaPlan.size, genislik: true, oran: 0.2)
        btnYenidenDene.olceklendir(boyut: arkaPlan.size, genislik: true, oran: 0.2)
        
        
        let arkaPlanGenislik = arkaPlan.size.width/2
        let arkaPlanYukseklik = arkaPlan.size.height/2
        let butonGenislik = btnIleri.size.width/2
        let butonYukseklik = btnIleri.size.height/2
        
        
        btnMenu.position = CGPoint(x: butonGenislik-arkaPlanGenislik, y: -(arkaPlanYukseklik+butonYukseklik))
        btnIleri.position = CGPoint(x: 0, y: -(arkaPlanYukseklik+butonYukseklik))
        btnYenidenDene.position = CGPoint(x: arkaPlanGenislik-butonGenislik, y: -(arkaPlanYukseklik+butonYukseklik))
        arkaPlan.position = CGPoint(x: 0, y: butonYukseklik)
        
        addChild(btnMenu)
        addChild(btnIleri)
        addChild(btnYenidenDene)
        addChild(arkaPlan)
        
        
        
    }
    
    func butonYoneticisi(index : Int) {
        
        switch index {
        case BitisMenuButonlari.menu :
            menuButonDelegate?.btnMenuPressed()
            break
        
        case BitisMenuButonlari.ileri :
            menuButonDelegate?.btnIleriPressed()
            break
        case BitisMenuButonlari.yenidenDene :
            menuButonDelegate?.btnYenidenDenePressed()
            break
        default :
            break
        }
        
        
    }
    
}

protocol MenuButonDelegate {
    
    func btnMenuPressed()
    func btnIleriPressed()
    func btnYenidenDenePressed()
    
}
