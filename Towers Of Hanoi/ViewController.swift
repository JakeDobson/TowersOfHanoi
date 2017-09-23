//  ViewController.swift
//  Towers Of Hanoi
//  Created by Jacob Dobson on 09/18/17
//  Copyright © 2017 Jacob Dobson. All rights reserved.
import UIKit
import SceneKit

class ViewController: UIViewController, SCNSceneRendererDelegate {
	//outlets
	@IBOutlet weak var numDiskLabel: UILabel!
	//instance of HanoiScene
	var scene: HanoiScene!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scnView = self.view as! SCNView
        scene = HanoiScene() as HanoiScene
        scnView.scene = scene
        
        scnView.backgroundColor = UIColor.black
        
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        //set scene to play
		scnView.play(nil)
    }
	//actions
	@IBAction func numDisksChanged(_ sender: UIStepper) {
		numDiskLabel.text = "\(sender.value)"
		scene.resetDisks(N: Int(sender.value))
		scene.playAnimation()
	}
	@IBAction func didTapRestart(_ sender: AnyObject) {
		scene.resetDisks(N: scene.numDisks)
		scene.playAnimation()
	}
}
