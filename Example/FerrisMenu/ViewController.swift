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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let diameter = 200
        ferrisMenu = FerrisMenu(frame: CGRect(x: 0,y: 0,width: diameter,height: diameter))
        ferrisMenu.backgroundColor = UIColor.yellowColor()
        ferrisMenu.alpha = 0
        ferrisMenu.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        self.view.addSubview(ferrisMenu)
        
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
                textColor: UIColor.whiteColor(),
                backgroundColor: UIColor.blueColor()),
            FerrisMenuItem(title: "bar",
                iconName: nil,
                target: self,
                selector: #selector(ViewController.buttonAction(_:)),
                font:nil,
                backgroundColor: UIColor.blueColor()),
            FerrisMenuItem(title: "mar",
                iconName: nil,
                target: self,
                selector: #selector(ViewController.buttonAction(_:)),
                font:nil,
                backgroundColor: UIColor.blueColor())
        ]
        
        //        ferrisMenu.createMenu(items)
        ferrisMenu.createMenu(iconItems)
    }
    
    func buttonAction(button:UIButton) {
        print("vc \(button.tag)")
        //ferrisMenu.hide()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showMenuAction(sender: AnyObject) {
        if ferrisMenu.displayed {
            print("hiding")
            ferrisMenu.hide()
        } else {
            print("displaying")
            ferrisMenu.display()
        }
    }
}

