//  HanoiScene.swift
//  Towers Of Hanoi
//  Created by Jacob Dobson on 09/18/17
//  Copyright © 2017 Jacob Dobson. All rights reserved.
import SceneKit

class HanoiScene: SCNScene {
	//create instance of HanoiSolver
	var hanoiSolver: HanoiSolver!
	//globals -- board
	var boardWidth: CGFloat = 0.0
	var boardLength: CGFloat = 0.0
	let boardPadding: CGFloat = 0.8
	let boardHeight: CGFloat = 0.2
	let diskRadius: CGFloat = 1.0
	//globals -- pegs
	var numDisks = 4
	var pegs: [SCNNode] = []
	var pegHeight: CGFloat = 0.0
	let pegRadius: CGFloat = 0.1
	let diskHeight: CGFloat = 0.2
	//globals -- disks
	var disks: [SCNNode] = []
	//life cycle
    override init() {
        super.init()
		//setup
		createBoard()
		createPegs()
		createDisks()
		hanoiSolver = HanoiSolver(numDisks: self.numDisks)
		playAnimation()
    }
	//setup board for pegs to be placed on top of
	func createBoard() {
		//set width and length
		boardWidth = diskRadius * 6.0 + boardPadding
		boardLength = diskRadius * 2.0 + boardPadding
		//set boardGeometry with previously defined vars, set color, create/add node to scene
		let boardGeometry = SCNBox(width: boardWidth, height: boardHeight, length: boardLength, chamferRadius: 0.1)
		boardGeometry.firstMaterial?.diffuse.contents = UIColor.brown
		let boardNode = SCNNode(geometry: boardGeometry)
		rootNode.addChildNode(boardNode)
	}
	//set up 3 pegs on top of board
	func createPegs() {
		pegHeight = CGFloat(numDisks + 1) * diskHeight
		//set x position of first peg
		var x: Float = Float((Float(-boardWidth / 2.0)) + (Float(boardPadding / 2.0)) + (Float(diskRadius)))
		//create pegs via for loop
		for _ in 0..<3 {
			//create peg geometry/color
			let peg = SCNCylinder(radius: pegRadius, height: pegHeight)
			let pegNode = SCNNode(geometry: peg)
			peg.firstMaterial?.diffuse.contents = UIColor.brown
			//position peg
			pegNode.position.x = x
			pegNode.position.y = Float((pegHeight / 2.0) + (boardHeight / 2.0))
			//add node to scene
			rootNode.addChildNode(pegNode)
			//append to array of pegs
			pegs.append(pegNode)
			//change x position for next peg before iterating again
			x += Float(diskRadius * 2)
		}
	}
	//place disk on pegs
	func createDisks() {
		//vars
		let firstPeg = pegs[0]
		var y: Float = Float(boardHeight / 2.0 + diskHeight / 2.0)
		var radius: CGFloat = diskRadius
		//create 4 disks via for loop
		for i in 0..<numDisks {
			//create disk geometry, hue, color, and create its node
			let disk = SCNTube(innerRadius: pegRadius, outerRadius: radius, height: diskHeight)
			disk.firstMaterial?.diffuse.contents = UIColor(hue: CGFloat(i) / CGFloat(numDisks), saturation: 1, brightness: 1, alpha: 1)
			let diskNode = SCNNode(geometry: disk)
			//set position of each node's x & y
			diskNode.position.x = firstPeg.position.x
			diskNode.position.y = y
			//add node to scene
			rootNode.addChildNode(diskNode)
			//append node to array of disks
			disks.append(diskNode)
			//adjust y position by diskHeight to place next disk on top of current disk being created
			y += Float(diskHeight)
			//decrease radius by 0.1 for each consequent disk in the iteration
			radius -= 0.1
		}
	}
	//animate Towers of Hanoi problem
	func animationFromMove(move: HanoiMove) -> SCNAction {
		//vars
		var duration = 0.0
		//constants
		let node = disks[move.diskIndex]
		let destination = pegs[move.destinationPegIndex]
		//move node to top position
		var topPosition = node.position
		topPosition.y = Float(pegHeight + diskHeight * 4.0)
		duration = normalizeDuration(startPostion: node.position, endPostion: topPosition)
		let moveUp = SCNAction.move(to: topPosition, duration: duration)
		//move node sideways
		var sidewaysPosition = destination.position
		sidewaysPosition.y = topPosition.y
		duration = normalizeDuration(startPostion: topPosition, endPostion: sidewaysPosition)
		let moveSideways = SCNAction.move(to: sidewaysPosition, duration: duration)
		//move node to bottomPosition
		var bottomPosition = sidewaysPosition
		bottomPosition.y = Float(boardHeight / 2.0 + diskHeight / 2.0) + Float(move.destinationDiskCount) * Float(diskHeight)
		duration = normalizeDuration(startPostion: sidewaysPosition, endPostion: bottomPosition)
		let moveDown = SCNAction.move(to: bottomPosition, duration: duration)
		//return sequence to animate
		return SCNAction.sequence([moveUp, moveSideways, moveDown])
	}
	//run animation recursively
	func recursiveAnimation(index: Int) {
		//constants
		let move = hanoiSolver.moves[index]
		let node = disks[move.diskIndex]
		let animation = animationFromMove(move: move)
		//run SCNAction w/ completionHandler
		node.runAction(animation, completionHandler: {
			if index + 1 < self.hanoiSolver.moves.count {
				self.recursiveAnimation(index: index + 1)
			}
		})
	}
	//func to play the animation recursively
	func playAnimation() {
		hanoiSolver.computeMoves()
		recursiveAnimation(index: 0)
	}
//begin: determine distance from one vector to another\\
	//calc length of vector
	func lengthOfVector(v: SCNVector3) -> Float {
		return sqrt(pow(v.x, 2.0) + pow(v.y, 2.0) + pow(v.z, 2.0))
	}
	//calc distance b/w vectors
	func distanceBetweenVectors(v1: SCNVector3, v2: SCNVector3) -> Float {
		return lengthOfVector(v: SCNVector3(x: v1.x - v2.x, y: v1.y - v2.y, z: v1.z - v2.z))
	}
//end: determine distance from one vector to another
	//normalize the duration of each action in the sequence(this makes every animation look the same speed)
	func normalizeDuration(startPostion: SCNVector3, endPostion: SCNVector3) -> Double {
		let referenceLength = distanceBetweenVectors(v1: pegs[0].position, v2: pegs[2].position)
		let length = distanceBetweenVectors(v1: startPostion, v2: endPostion)
		return 0.3 * Double(length / referenceLength)
	}
	//reset scene to replat animation over and over and over again
	func resetDisks(N: Int) {
		self.numDisks = N
		for peg in pegs {
			peg.removeAllAnimations()
			peg.removeFromParentNode()
		}
		pegs = []
		createPegs()
		for disk in disks {
			disk.removeFromParentNode()
		}
		disks = []
		createDisks()
		hanoiSolver = HanoiSolver(numDisks: self.numDisks)
	}
    //decoder init -- error handling
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
