//
//  SubsetSumSwift.swift
//  SubsetSumSwift
//
//  Created by Scotty Shaw on 6/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class SubsetSumSwift : CCNode {
    
    func didLoadFromCCB () {
        mainMethod()
    }
    
    func mainMethod () {
        var target : Int = 100000000
        var populations : [Int] = [18897109, 12828837, 9461105, 6371773, 5965343, 5946800, 5582170, 5564635, 5268860, 4552402, 4335391, 4296250, 4224851, 4192887, 3439809, 3279833, 3095313, 2812896, 2783243, 2710489, 2543482, 2356285, 2226009, 2149127, 2142508, 2134411]
        
        populations.sort { $0 < $1 }
        
        var counter : Int = 0
        
        // remove values that exceed the target
        for i in 0...(populations.count - 1) {
            if populations[i] <= target {
                counter++
            }
        }
        
        if counter < populations.count {
            populations.removeRange(counter...(populations.count - 1))
        }
        
        println()
        println("START")
        println()
        
        // recursive programming; runtime O(n^2)
        let isTargetTheSumOfAnySubset : Bool = checkForTargetInAllSubsets(populations, 0, target, [Int]())
        
        // dynamic programming; runtime O(nk)
        //        let isTargetTheSumOfAnySubset : Bool = checkForTargetInAllSubsets(populations, target)
        
        if (isTargetTheSumOfAnySubset) {
            println(String(format:"The sum of this subset is equal to %d", target))
        }
        else {
            println(String(format:"No sums of any subsets in this set are equal to %d", target))
        }
        
        println()
        println("FINISHED")
        println()
    }
    
    // recursive programming; runtime O(n^2)
    func checkForTargetInAllSubsets (a : [Int], _ n : Int, _ target : Int, _ subset : [Int]) -> Bool {
        
        // the sum of this combination is equal to target
        if (target == 0) {
            println(subset)
            return true
        }
        
        // the sum of this combination is greater than target
        if (target < 0) {
            return false
        }
        
        // the sum of this combination is less than target
        if (n == a.count) {
            return false
        }
        
        var subset2 = subset
        subset2.append(a[n])
        
        return checkForTargetInAllSubsets(a, n + 1, target, subset) || checkForTargetInAllSubsets(a, n + 1, target - a[n], subset2)
    }
    
    // dynamic programming; runtime O(nk)
    func checkForTargetInAllSubsets (a : [Int], _ target : Int) -> Bool {
        
        var subset : [Int] = []
        
        // all sets can achieve the target value of 0
        if target == 0 {
            println(subset)
            return true
        }
        
        var copy : [Int] = a
        var n : Int = copy.count
        
        // create the boolean table
        var table = [[Bool]](count: n + 1, repeatedValue: [Bool](count: target + 1, repeatedValue: false))
        for i in 0...n {
            table[i][0] = true
        }
        
        // fill in true and false values
        for i in 1...n {
            table[i] = table[i - 1]
            for j in 1...target {
                if (j >= copy[i - 1]) {
                    if (table[i][j] == false) {
                        table[i][j] = table[i - 1][j] || table[i - 1][j - copy[i - 1]]
                    }
                }
            }
        }
        
        var i : Int = n
        var j : Int = target
        var x : Int = copy.count - 1
        
        // create and print the subset whose sum equals the target, if it exists
        if (table[n][target]) {
            while (i >= 0 && j >= 0) {
                if (table[i][j]) {
                    i--
                }
                else {
                    x = copy.count - 1
                    while (x >= 0) {
                        if (j - copy[x] >= 0) {
                            if (table[i][j - copy[x]]) {
                                subset.append(copy[x])
                                j -= copy[x]
                                copy.removeRange(x...(copy.count - 1))
                                break
                            }
                        }
                        x--
                    }
                }
            }
            println(subset)
        }
        
        return table[n][target]
    }
}
