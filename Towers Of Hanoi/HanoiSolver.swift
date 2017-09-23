//  HanoiSolver.swift
//  Towers Of Hanoi
//  Created by Jacob Dobson on 09/18/17
//  Copyright © 2017 Jacob Dobson. All rights reserved.
import UIKit
//struct -- data for animating movement of disks
struct HanoiMove {
	var diskIndex: Int
	var destinationPegIndex: Int
	var destinationDiskCount: Int
	//init
	init(diskIndex: Int, destinationPegIndex: Int, destinationDiskCount: Int) {
		self.diskIndex = diskIndex
		self.destinationPegIndex = destinationPegIndex
		self.destinationDiskCount = destinationDiskCount
	}
}
//Hanoi Solver Class -- generates solution to Towers of Hanoi "problem"
class HanoiSolver {
	//globals
	var numDisks: Int
	var leftPeg: [Int]
	var middlePeg: [Int]
	var rightPeg: [Int]
	var pegs: [[Int]]
	var moves: [HanoiMove]
	//init
	init(numDisks: Int) {
		self.numDisks = numDisks
		//leftPeg
		self.leftPeg = []
		for i in 0..<numDisks {
			self.leftPeg.append(i)
		}
		//middlePeg, rightPeg
		self.middlePeg = []
		self.rightPeg = []
		//initialize pegs array of arrays(left/mid/right)
		self.pegs = [leftPeg, middlePeg, rightPeg]
		//init empty moves array
		self.moves = []
	}
	//hanoi algo
	func hanoi(numDisks: Int, from: Int, using: Int, to: Int) {
		if numDisks == 1 {
			move(from: from, to: to)
		} else {
			hanoi(numDisks: numDisks - 1, from: from, using: to, to: using)
			move(from: from, to: to)
			hanoi(numDisks: numDisks - 1, from: using, using: from, to: to)
		}
	}
	//func for creating 'HanoiMoves' and updating disks array, popDisk via "from" peg, pushDisk via "to" peg
	func move(from: Int, to: Int) {
		//vars
		let disk = popDisk(peg: from)
		let diskIndex = disk
		let destinationDiskCount = pegs[to].count
		//push disk
		pushDisk(disk: disk, peg: to)
		//move disks
		let move = HanoiMove(diskIndex: diskIndex, destinationPegIndex: to, destinationDiskCount: destinationDiskCount)
		moves.append(move)
	}
	//popDisk method
	func popDisk(peg: Int) -> Int {
		return pegs[peg].removeLast()
	}
	//pushDisk method
	func pushDisk(disk: Int, peg: Int) {
		pegs[peg].append(disk)
	}
	//func for computing moves
	func computeMoves() {
		self.moves = []
		hanoi(numDisks: numDisks, from: 0, using: 1, to: 2)
	}
}

