//
//  ViewController.swift
//  FerrisMenu
//
//  Created by Gene De Lisa on 04/18/2016.
//  Copyright (c) 2016 Gene De Lisa. All rights reserved.
//

import UIKit
import FerrisMenu
class ViewController: UIViewController {

    var ferrisMenu:FerrisMenu!
    var textFerrisMenu:FerrisMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let diameter = 200
        ferrisMenu = FerrisMenu(frame: CGRect(x: 0,y: 0,width: diameter,height: diameter))
        ferrisMenu.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
        ferrisMenu.alpha = 0
        ferrisMenu.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        ferrisMenu.hideOnButtonAction = true
        ferrisMenu.stationary = false
        ferrisMenu.delegate = self
        self.view.addSubview(ferrisMenu)
       
        textFerrisMenu = FerrisMenu(frame: CGRect(x: 0,y: 0,width: diameter,height: diameter))
        textFerrisMenu.backgroundColor = UIColor.orange.withAlphaComponent(0.6)
        textFerrisMenu.alpha = 0
        textFerrisMenu.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        textFerrisMenu.hideOnButtonAction = true
        textFerrisMenu.stationary = false
        textFerrisMenu.delegate = self
        textFerrisMenu.rotateOnDisplay = true
        self.view.addSubview(textFerrisMenu)

        
        let iconItems = [
            FerrisMenuItem(title: nil,
                iconName: "social_lastfm_button_red_32",
                target: self,
                selector: #selector(ViewController.buttonAction(_:))
            ),
            FerrisMenuItem(title: nil,
                iconName: "social_linkedin_button_blue_32",
                target: self,
                selector: #selector(ViewController.buttonAction(_:))
            ),
            FerrisMenuItem(title: nil,
                iconName: "social_reddit_button_32",
                target: self,
                selector: #selector(ViewController.buttonAction(_:))
            ),
            FerrisMenuItem(title: nil,
                iconName: "social_skype_button_blue_32",
                target: self,
                selector: #selector(ViewController.buttonAction(_:))
            ),
            FerrisMenuItem(title: nil,
                iconName: "social_twitter_button_blue_32",
                target: self,
                selector: #selector(ViewController.buttonAction(_:))
            )
        ]
        
        let items = [
            FerrisMenuItem(title: "foo",
                iconName: nil,
                target: self,
                selector: #selector(ViewController.buttonAction(_:)),
                font:nil,
                textColor: UIColor.white,
                backgroundColor: UIColor.blue),
            FerrisMenuItem(title: "bar",
                iconName: nil,
                target: self,
                selector: #selector(ViewController.buttonAction(_:)),
                font: UIFont.boldSystemFont(ofSize: 36),
                textColor: UIColor.white,
                backgroundColor: UIColor.green),
            FerrisMenuItem(title: "really long label",
                iconName: nil,
                target: self,
                selector: #selector(ViewController.buttonAction(_:)),
                font:nil,
                textColor: UIColor.yellow,
                backgroundColor: UIColor.blue)
        ]
        
        textFerrisMenu.createMenu(items)
        ferrisMenu.createMenu(iconItems)
    }
    
    func buttonAction(_ button:UIButton) {
        print("vc \(button.tag)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showMenuAction(_ sender: AnyObject) {
        if ferrisMenu.displayed {
            print("hiding")
            ferrisMenu.hide()
        } else {
            print("displaying")
            ferrisMenu.display()
        }
    }
    
    @IBAction func showTextMenuAction(_ sender: AnyObject) {
        if textFerrisMenu.displayed {
            textFerrisMenu.hide()
        } else {
            textFerrisMenu.display()
        }
    }
}

extension ViewController : FerrisMenuDelegate {
    func angleDidChange(_ radians: CGFloat) {
        print("angle \(radians)")
    }
}


