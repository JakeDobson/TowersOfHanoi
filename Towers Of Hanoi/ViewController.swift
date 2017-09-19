//  ViewController.swift
//  Towers Of Hanoi
//  Created by Jacob Dobson on 09/18/17
//  Copyright © 2017 Jacob Dobson. All rights reserved.
import UIKit
import SceneKit

class ViewController: UIViewController, SCNSceneRendererDelegate {
    var scene: HanoiScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scnView = self.view as! SCNView
        scene = HanoiScene() as HanoiScene
        scnView.scene = scene
        
        scnView.backgroundColor = UIColor.black
        
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        
    }
}
