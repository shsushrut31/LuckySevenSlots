//
//  GameScene.swift
//  LuckySevensSlots
//
//  Created by Sushrut Shastri on 2017-04-04.
//  Copyright © 2017 Sushrut Shastri. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    
    let background = SKSpriteNode(imageNamed: "slotmachine")
    let spinbutton = SKSpriteNode(imageNamed: "spin")
    let resetbutton = SKSpriteNode(imageNamed: "reset")
    let resetbuttonpressed = SKSpriteNode(imageNamed: "resetpressed")
    let betbutton = SKSpriteNode(imageNamed: "bet")
    let betmaxbutton = SKSpriteNode(imageNamed: "betmax")
    let bet = SKLabelNode()
    let price = SKLabelNode()
    let totalCredit = SKLabelNode()
    let message = SKLabelNode()
    
    //var resetActive:Bool = false
    var currentbet = 0
    var currentbalance = 0
    var priceWon = 0
    
    
    var seven1 = SKSpriteNode(imageNamed: "7")
    var seven2 = SKSpriteNode(imageNamed: "7")
    var seven3 = SKSpriteNode(imageNamed: "7")
    
    var imageSpin1:String = ""
    var imageSpin2:String = ""
    var imageSpin3:String = ""
    
    //Array of images
    let slotItems = ["7","bar","Bell","cherry","crown","dollar", "lemon"]

    override func didMove(to view: SKView) {
        
        //play background music
        let music = SKAudioNode(fileNamed: "background.mp3")
        addChild(music)
        
        music.isPositional = true
        music.position = CGPoint(x: -500, y: 500)
        
        let moveForward = SKAction.moveTo(x: 500, duration: 0.5)
        let moveBack = SKAction.moveTo(x: -500, duration: 0.5)
        let sequence = SKAction.sequence([moveForward, moveBack])
        let repeatForever = SKAction.repeatForever(sequence)
        
        //repeat music
        music.run(repeatForever)
        
        //set anchor point
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        //set slot machine as background and other buttons positions
        background.size = size
        self.addChild(background);
        
        
        resetbutton.position = CGPoint(x: -263, y: -470)
        resetbutton.scale(to: CGSize(width:125, height:185))
        self.addChild(resetbutton);
        
        
        betbutton.position = CGPoint(x: -110, y: -470)
        betbutton.scale(to: CGSize(width:125, height:185))
        self.addChild(betbutton);
        
        
        betmaxbutton.position = CGPoint(x: 40, y: -470)
        betmaxbutton.scale(to: CGSize(width:125, height:185))
        self.addChild(betmaxbutton);
        
        
        spinbutton.position = CGPoint(x: 190, y: -470)
        spinbutton.scale(to: CGSize(width:125, height:185))
        self.addChild(spinbutton);
        
        
        //set slot images position
        seven1.position = CGPoint(x: -170, y: -20)
        seven1.scale(to: CGSize(width:155, height:297))
        self.addChild(seven1);
        
        
        seven2.position = CGPoint(x: 0, y: -20)
        seven2.scale(to: CGSize(width:155, height:297))
        self.addChild(seven2);
        
        
        seven3.position = CGPoint(x: 170, y: -20)
        seven3.scale(to: CGSize(width:155, height:297))
        self.addChild(seven3);
        
        //set labels positions
        
        bet.position = CGPoint(x: 0, y: -290)
        bet.fontSize = 45.0
        bet.text = "1000"
        bet.zPosition = 100
        addChild(bet)
        
        totalCredit.position = CGPoint(x: -240, y: -290)
        totalCredit.fontSize = 45.0
        totalCredit.text = "5000"
        totalCredit.zPosition = 100
        addChild(totalCredit)
        
        price.position = CGPoint(x: 230, y: -290)
        price.fontSize = 45.0
        price.text = "0"
        price.zPosition = 100
        addChild(price)
        
        message.position = CGPoint(x: 0, y: 170)
        message.fontSize = 35.0
        message.text = "Good Luck"
        message.zPosition = 100
        addChild(message)

        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            _ = touch.location(in: self);
            
            //do this on reset button click
            if resetbutton.contains(touch.location(in: self))
            {
                totalCredit.text = "5000"
                bet.text = "500"
                price.text = "0"
                message.fontSize = 35.0
                message.text = "Good Luck"
                spinbutton.texture = SKTexture(imageNamed: "spin")
               // resetActive = false
                
            }
            
            //do this on bet button click
            if betbutton.contains(touch.location(in: self))
            {
                currentbet = Int(bet.text!)!
                currentbalance = Int(totalCredit.text!)!
                
                if (currentbet < currentbalance){
                
                    currentbet = currentbet + 500
                }
                else{
                    currentbet = 500
                }
               
                bet.text = String(currentbet)
            }
            
            //do this on bet max button click
            if betmaxbutton.contains(touch.location(in: self))
            {
                currentbalance = Int(totalCredit.text!)!
                
            
                bet.text = String(currentbalance)
            }
            
            //do this on spin button click
            if spinbutton.contains(touch.location(in: self))
            {
                //play slot spin audio on spin button click
                self.run(SKAction.playSoundFileNamed("slotspin.mp3", waitForCompletion: false))
                currentbet = Int(bet.text!)!
                currentbalance = Int(totalCredit.text!)!
                spinbutton.texture = SKTexture(imageNamed: "spinpressed")
                
                 if (currentbet > currentbalance){
                   message.text = "Reset to Play!!"
                 }
                 else{
                    currentbalance = currentbalance - currentbet
                    totalCredit.text = String(currentbalance)
                    
                   //
                    let spinfirst:SKAction = SKAction.run({
                        self.spinning(slotNumber: 1)
                    })
                    
                    let spinsecond:SKAction = SKAction.run({
                        self.spinning(slotNumber: 2)
                    })
                    
                    let spinthird:SKAction = SKAction.run({
                        self.spinning(slotNumber: 3)
                    })
                    
                    let counting:SKAction = SKAction.run({
                        self.jackpotCount()
                    })
                    
                    self.run(SKAction.sequence([spinfirst, spinsecond, spinthird, counting]))

                }
            }
        }
    }
    
    //spin the slots
    
    func spinning(slotNumber:Int){
        
        //select random number from number of images in array
        let random:UInt32 = arc4random_uniform(UInt32(slotItems.count))
        
        //select image from random array location
        let spinSlot:String  = slotItems[Int(random)]
        
        //change image texture for all three slots
        if (slotNumber == 1){
            imageSpin1 = spinSlot
            seven1.texture = SKTexture(imageNamed: imageSpin1)
        }
            
        else  if (slotNumber == 2){
            imageSpin2 = spinSlot
            seven2.texture = SKTexture(imageNamed: imageSpin2)
        }
            
        else if (slotNumber == 3){
            imageSpin3 = spinSlot
            seven3.texture = SKTexture(imageNamed: imageSpin3)
        }
        
    }
    
    // calculate account balance and wins
    func jackpotCount(){
        currentbet = Int(bet.text!)!
        currentbalance = Int(totalCredit.text!)!
        priceWon = Int(price.text!)!
        spinbutton.texture = SKTexture(imageNamed: "spin")
        
        // all three slots same but not lucky sevens
        if(imageSpin1 == imageSpin2 && imageSpin2 == imageSpin3 && imageSpin1 != "7"){
            
            self.run(SKAction.playSoundFileNamed("jackpot1.mp3", waitForCompletion: false))
            //win three times
            priceWon = currentbet * 3
            currentbalance = currentbalance + priceWon
            message.text = "You Won !!!"
            totalCredit.text = String(currentbalance)
            price.text = String(priceWon)
            spinbutton.texture = SKTexture(imageNamed: "spin")
        }
            //any two slots same
        else if(imageSpin1 == imageSpin2 || imageSpin2==imageSpin3 || imageSpin3==imageSpin1){
            
            self.run(SKAction.playSoundFileNamed("dues.mp3", waitForCompletion: false))
            //win twice
            priceWon = currentbet * 2
            currentbalance = currentbalance + priceWon
            message.text = "You Won !!!"
            totalCredit.text = String(currentbalance)
            price.text = String(priceWon)
            spinbutton.texture = SKTexture(imageNamed: "spin")
        }
            //jackpot hit (lucky sevens)
        else if(imageSpin1 == "7" && imageSpin2 == "7" && imageSpin3 == "7"){
            
            self.run(SKAction.playSoundFileNamed("luckysevens.mp3", waitForCompletion: false))
            //win seven times
            priceWon = currentbet * 7
            currentbalance = currentbalance + priceWon
            message.text = "Jackpot !!!"
            totalCredit.text = String(currentbalance)
            price.text = String(priceWon)
            spinbutton.texture = SKTexture(imageNamed: "spin")
        }
        else{
            //no win
            message.text = "Try Again !!!"
            price.text = "0"
            spinbutton.texture = SKTexture(imageNamed: "spin")
        }
        
    }
    
    
   
    
}
