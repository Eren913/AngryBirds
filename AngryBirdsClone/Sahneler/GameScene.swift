//
//  GameScene.swift
//  AngryBirdsClone
//
//  Created by Furkan Sabaz on 12.07.2019.
//  Copyright © 2019 Furkan Sabaz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var sahneYoneticiDelegate : SahneYoneticiDelegate?
    let oyunKamera = OyunKamera()
    var mapNode = SKTileMapNode()
    var panGR = UIPanGestureRecognizer()
    var pinchGR = UIPinchGestureRecognizer()
    var maxOlcek : CGFloat = 0
    var kus = Kus(kusTipi: .Mavi)
    var kuslar =  [Kus]()
    var levelSayi : Int?
    let anchor = SKNode()
    var oyunDurumu : OyunDurumu = .Hazir
    var puan = 0
    let lblPuan = SKLabelNode(fontNamed: "Avenir-Black")
    var dusmanSayisi = 0 {
        didSet {
            if dusmanSayisi < 1 {
                
                if let level = levelSayi {
                    let veriler = UserDefaults.standard
                    veriler.set(level+1, forKey: "maxLevel")
                    veriler.set(puan, forKey: "puan")
                    
                }
                bitisMenuGoster(basarili: true)
            }
        }
        
    }
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        puan = UserDefaults.standard.integer(forKey: "puan")
        puanEkle()
        
        guard let levelSayi = levelSayi else { return}
        
        guard let levelVeri = Level(level: levelSayi) else { return }
        
        for renk in levelVeri.kuslar {
            if let yeniKusTipi = KusTipi(rawValue: renk) {
                
                let yeniKus = Kus(kusTipi: yeniKusTipi)
                kuslar.append(yeniKus)
                
            }
        }
        
        
        
        setupLevel()
        hazirlaGR()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch oyunDurumu {
        case .Hazir :
            if let touch = touches.first {
                let konum = touch.location(in: self)
                if kus.contains(konum) {
                    panGR.isEnabled = false
                    kus.secildiMi = true
                    kus.position = konum
                }
            }
            break
        case .Ucuyor :
            break
        case .Bitis :
            guard let view = view else {return}
            oyunDurumu = .Dirilme
            let kameraGeriAction = SKAction.move(to: CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2), duration: 2.0)
            kameraGeriAction.timingMode = .easeInEaseOut
            oyunKamera.run(kameraGeriAction, completion: {
                self.panGR.isEnabled = true
                self.kusEkle()
            })
            break
        case .Dirilme :
            break
        case .OyunBitti :
            break
        default :
            break
            
        }
        
        
        
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if kus.secildiMi {
                let konum = touch.location(in: self)
                kus.position = konum
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if kus.secildiMi {
            
            oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: kus)
            
            kus.secildiMi = false
            panGR.isEnabled = true
            anchorSinirlariniBelirle(aktif: false)
            
            kus.ucuyorMu = true
            oyunDurumu = .Ucuyor
            
            let xFark = anchor.position.x - kus.position.x
            let yFark = anchor.position.y - kus.position.y
            
            let impulse = CGVector(dx: xFark, dy: yFark)
            kus.physicsBody?.applyImpulse(impulse)
            kus.isUserInteractionEnabled = false
            
            
            
        }
    }
    
    func kameraEkle() {
        
        addChild(oyunKamera)
        guard let view = view else {return}
        
        oyunKamera.setScale(maxOlcek)
        oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
        oyunKamera.position = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        camera = oyunKamera
    }
    
    func hazirlaGR() {
        
        guard let view = view else {return}
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        
        pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchGR)
    }
    
    @objc func pinch(p : UIPinchGestureRecognizer) {
        
        guard let view = view else { return }
        if p.numberOfTouches == 2 { //Kullanıcının ekranda dokunduğu nokta sayısı
            
            let konumView = p.location(in: view) // pinch işleminin hangi konumda olduğunu verir
            let konum = convertPoint(fromView: konumView) // pinch ölçeklendirme işlemi yapmadan önceki konumu verir
            if p.state  == .changed {
                
                let olcek = 1 / p.scale // bu ölçeği kameranın yeni göstereceği ölçeği hesaplamak için tanımladık
                let yeniOlcek = oyunKamera.yScale*olcek
                
                //print("Yeni Ölçek :  \(yeniOlcek)")
                if yeniOlcek < maxOlcek && yeniOlcek > 0.5 {
                    oyunKamera.setScale(yeniOlcek)
                }
                
                
                let olcekSonrasiKonum = convertPoint(fromView: konumView)
                
                let konumDelta  = konum - olcekSonrasiKonum
                let yeniKonum = oyunKamera.position + konumDelta
                
                
                oyunKamera.position = yeniKonum
                p.scale = 1.0
                oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
            }
            
        }
        
        
        
    }
    @objc func pan(p : UIPanGestureRecognizer) {
        
        guard let view = view else {return}
        
        let hareket = p.translation(in: view) * oyunKamera.yScale
        oyunKamera.position = CGPoint(x: oyunKamera.position.x-hareket.x, y: oyunKamera.position.y + hareket.y)
        oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
        p.setTranslation(CGPoint.zero, in: view)
    }
    
    func setupLevel() {
        
        if let map = childNode(withName: "Tile Map Node") as? SKTileMapNode {
            self.mapNode = map
            maxOlcek = mapNode.mapSize.width / frame.size.width
            //print(maxOlcek)
        }
        kameraEkle()
        
        for node in mapNode.children {
            
            if let node = node as? SKSpriteNode {
                
                guard let adi = node.name else { continue}
                
                
                switch adi {
                case "Cam","Tas","Tahta" :
                    if let blok = blokEkle(node: node, adi: adi) {
                        mapNode.addChild(blok)
                        node.removeFromParent()
                    }
                    break
                
                case "TuruncuDusman","YesilDusman" :
                    if let dusman = dusmanEkle(node: node, adi: adi) {
                        mapNode.addChild(dusman)
                        dusmanSayisi += 1
                        node.removeFromParent()
                    }
                    break
                case "Altin1" , "Altin2" :
                    
                    if let altin = altinEkle(node: node, adi: adi) {
                        mapNode.addChild(altin)
                        node.removeFromParent()
                    }
                    break
                default :
                    break
                }
                
            }
            
            
        }
        
        let rect = CGRect(x: 0, y: mapNode.tileSize.height, width: mapNode.frame.size.width, height: mapNode.frame.size.height - mapNode.tileSize.height)
        physicsBody = SKPhysicsBody(edgeLoopFrom: rect)
        
        print(mapNode.tileSize.height)
        print(mapNode.frame.size.width)
        print(mapNode.frame.size.height)
        
        
        physicsBody?.categoryBitMask = FizikKategorileri.kenar
        physicsBody?.contactTestBitMask = FizikKategorileri.kus | FizikKategorileri.blok
        physicsBody?.collisionBitMask = FizikKategorileri.tumu
        
        
        anchor.position = CGPoint(x: frame.width/2, y: (frame.height/2)*1)
        addChild(anchor)
        kusEkle()
        sapanEkle()
    }
    
    func altinEkle(node: SKSpriteNode, adi : String) -> Altin? {
        guard let altinTipi = AltinTipi(rawValue: adi) else { return nil}
        
        let altin = Altin(tipi: altinTipi)
        
        altin.position = node.position
        altin.size = node.size
        altin.bodyOlustur()
        altin.zPosition = ZPozisyon.kus
        altin.zRotation = node.zRotation
        return altin
    }
    
    func blokEkle(node : SKSpriteNode, adi : String) -> Blok? {
        guard let blokTipi = BlokTipi(rawValue: adi) else {  return nil }
        let blok = Blok(tipi: blokTipi)
        
        
        blok.position = node.position
        blok.size = node.size
        blok.zPosition = ZPozisyon.engeller
        blok.zRotation = node.zRotation
        blok.bodyOlustur()
        return blok
        
    }
    
    func dusmanEkle(node : SKSpriteNode, adi : String) -> Dusman? {
        
        guard let dusmanTipi = DusmanTipi(rawValue: adi) else {return nil}
        
        let dusman = Dusman(dusmanTipi: dusmanTipi)
        
        dusman.size = node.size
        dusman.position = node.position
        dusman.olusturBody()
        return dusman
        
    }
    
    func sapanEkle() {
        
        let sapan = SKSpriteNode(imageNamed: "sapan")
        
        let olcekBoyut = CGSize(width: 0, height: mapNode.frame.midY/2 - mapNode.tileSize.height/2)
        
        sapan.olceklendir(boyut: olcekBoyut, genislik: false, oran: 1)
        
        sapan.position = CGPoint(x: anchor.position.x, y: sapan.size.height/2 + mapNode.tileSize.height)
        
        sapan.zPosition = ZPozisyon.engeller
        
        mapNode.addChild(sapan)
        
    }
    
    
    
    func kusEkle(){
        
        if kuslar.isEmpty {
            print("Hakkınız Bitti")
            oyunDurumu = .OyunBitti
            bitisMenuGoster(basarili: false)
            return
        }
        print("Kuş geliyor")
        kus = kuslar.removeFirst()
        oyunDurumu = .Hazir
        
        kus.physicsBody = SKPhysicsBody(rectangleOf: kus.size)
        kus.physicsBody?.categoryBitMask = FizikKategorileri.kus
        kus.physicsBody?.contactTestBitMask = FizikKategorileri.tumu
        kus.physicsBody?.collisionBitMask = FizikKategorileri.blok | FizikKategorileri.kenar
        kus.physicsBody?.isDynamic = false
        
        kus.position = anchor.position
        kus.zPosition = ZPozisyon.kus
        kus.olceklendir(boyut: mapNode.tileSize, genislik: true, oran: 1.0)
        addChild(kus)
        anchorSinirlariniBelirle(aktif: true)
    }
    
    func anchorSinirlariniBelirle(aktif : Bool) {
        
        if aktif {
            
            let gerilmeAralik = SKRange(lowerLimit: 0.0, upperLimit: kus.size.width*2.8)
            
            let kusConstraint = SKConstraint.distance(gerilmeAralik, to: anchor)
            kus.constraints = [kusConstraint]
        } else {
            kus.constraints?.removeAll()
        }
    }
    
    override func didSimulatePhysics() {
        guard let body = kus.physicsBody else { return }
        
        if oyunDurumu == .Ucuyor && body.isResting {
            oyunKamera.sinirlariBelirle(sahne: self, frame: mapNode.frame, node: nil)
            kus.removeFromParent()
            oyunDurumu = .Bitis
        }
        
    }
    
    func bitisMenuGoster(basarili : Bool){
        
        let tipi = basarili ? 1 : 2
        let menu = BitisMenu(tipi: tipi, boyut: frame.size)
        
        menu.zPosition = ZPozisyon.oyunDisiArkaPlan
        
        menu.menuButonDelegate = self
        oyunKamera.addChild(menu)
        
    }
    
    
    func puanEkle() {
        
        let ekranBoyutu = UIScreen.main.bounds
        let ekranGenislik = ekranBoyutu.width
        let ekranYukseklik = ekranBoyutu.height
        
        lblPuan.position = CGPoint(x: ekranGenislik/2.1, y: ekranYukseklik/2.5)
        lblPuan.fontColor = .black
        lblPuan.text = "Puan : \(puan)"
        lblPuan.verticalAlignmentMode = .top
        lblPuan.horizontalAlignmentMode = .right
        lblPuan.fontSize = 25
        
        
        lblPuan.zPosition = ZPozisyon.engeller
        oyunKamera.addChild(lblPuan)
        
    }
}



extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch mask {
            
        case FizikKategorileri.kus | FizikKategorileri.blok , FizikKategorileri.blok | FizikKategorileri.kenar:
            
            if let blok = contact.bodyA.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            } else if let blok = contact.bodyB.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            }
            
            
            if let kus = contact.bodyA.node as? Kus {
                kus.ucuyorMu = false
            } else if let kus = contact.bodyB.node as? Kus {
                kus.ucuyorMu = false
            }
            
            break
            
            
        case FizikKategorileri.blok | FizikKategorileri.blok :
            
            if let blok = contact.bodyA.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            }
            if let blok = contact.bodyB.node as? Blok {
                blok.carpisma(guc: Int(contact.collisionImpulse))
            }
            break
        
        case FizikKategorileri.kus | FizikKategorileri.kenar :
            kus.ucuyorMu = false
            break
        
            
        case FizikKategorileri.kus | FizikKategorileri.dusman , FizikKategorileri.blok | FizikKategorileri.dusman :
            if let dusman = contact.bodyA.node as? Dusman {
                if dusman.carpisma(guc: Int(contact.collisionImpulse)) {
                    //düşman ölmüştür.
                    
                    dusmanSayisi = dusmanSayisi - 1
                }
            } else if let dusman = contact.bodyB.node as? Dusman {
                if dusman.carpisma(guc: Int(contact.collisionImpulse)) {
                    dusmanSayisi = dusmanSayisi - 1
                }
            }
            break
            
        case FizikKategorileri.kus | FizikKategorileri.altin :
            if let altin = contact.bodyA.node as? Altin {
                puan += altin.carpisma()
            } else if let altin = contact.bodyB.node as? Altin {
                puan += altin.carpisma()
            }
            lblPuan.text = "Puan : \(puan)"
            print("Altına Çarptın ve Güncel Puanın : \(puan)")
            break
        default :
            break
            
        }
        
        
    }
}


extension GameScene : MenuButonDelegate {
    func btnMenuPressed() {
        sahneYoneticiDelegate?.gosterLevelSahnesi()
    }
    
    func btnIleriPressed() {
        
        if let level = levelSayi {
            sahneYoneticiDelegate?.gosterOyunSahnesi(level: level+1)
        }
    }
    
    func btnYenidenDenePressed() {
        if let level = levelSayi {
            sahneYoneticiDelegate?.gosterOyunSahnesi(level: level)
        }
    }
    
    
}
