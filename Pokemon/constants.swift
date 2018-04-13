//
//  constants.swift
//  Pokemon
//
//  Created by Peter Lin on 3/27/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import Foundation

var locations = ["Viridian Forest", "Mt Moon", "Route 5"]
var costs = [5, 7, 10]
var expvalues =
[   "Caterpie" : 100,
        "Weedle" : 100,
        "Pikachu" : 100,
        "Geodude" : 6,
        "Zubat" : 4,
        "Clefairy" : 7
]

var moneyvalues =
    [   "Caterpie" : 4,
        "Weedle" : 3,
        "Pikachu" : 5,
        "Geodude" : 4,
        "Zubat" : 6,
        "Clefairy" : 7
]

var locLevels =
    [   "Viridian Forest" : 5,
        "Mt Moon" : 7,
        "Route 5" : 10
]

var pokemonMoveList = [
    "Caterpie" : ["Tackle"],
    "Weedle" : ["Poison Sting"],
    "Pikachu" : ["Thunder Shock", "Tackle"],
    "Geodude" : ["Tackle"],
    "Zubat" : ["Leech Life"],
    "Jigglypuff" : ["Pound", "Double Slap"]
]

var multipliers = [
    "water" : ["adv" : ["fire", "ground", "rock"], "disadv" : ["water", "grass", "dragon"]],
    "fire" : ["adv" : ["grass", "ice", "bug", "steel"], "disadv" : ["water", "fire", "rock", "dragon"]],
    "grass" : ["adv" : ["water", "ground", "rock"], "disadv" : ["fire", "grass", "poison", "flying", "bug", "dragon"]],
    "normal" : ["adv" : [], "disadv" : ["rock", "steel"], "immune":"ghost"],
    "electric" : ["adv" : ["water", "flying", "rock"], "disadv" :  ["electric", "grass", "dragon"], "immune" : "ground"]
    
]
    








