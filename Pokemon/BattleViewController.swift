//
//  BattleViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/27/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData

class BattleViewController: UIViewController {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var pokemon: String?
    var delegate: EventDelegate?
    var area: String?
    var user = User()
    var level :Int!
    
    
    @IBOutlet weak var type1: UIImageView!
    @IBOutlet weak var type2: UIImageView!
    var mypoke = Pokemon()
    var enemypoke = AllPokemon()
    
    @IBOutlet weak var yourPokemonFront: UIImageView!
    @IBOutlet weak var enemyPokemon: UIImageView!
    @IBOutlet weak var yourPokemon: UIImageView!
    
    @IBOutlet weak var yourPokemonLog: UILabel!
    @IBOutlet weak var enemyPokemonLog: UILabel!
    var enemyPokeStats: [String: Any] = [:]
    var yourPokeStats: [String: Any] = [:]
    var moves:[String] = []
    var enemymoves:[String] = []
    @IBOutlet var fightButtons: [UIButton]!
    
    
    @IBOutlet weak var enemyHPLabel: UILabel!
    @IBOutlet weak var yourHPLabel: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = fetchUser()
        enemymoves = pokemonMoveList[pokemon!]!
        pokemon = pokemon!.lowercased()

        
        enemyPokemon.alpha = 0
        yourPokemon.alpha = 0
        mypoke = fetchMyPokemon()
        enemypoke = fetchAnyPokemon(name: pokemon!)
        moves = mypoke.moves!
        level = locLevels[area!]
        
        
        for i in 0..<fightButtons.count{
            if i < (moves.count){
                fightButtons[i].setTitle(moves[i], for: .normal)
            }
            else{
                fightButtons[i].setTitle("", for: .normal)
            }
        }
        

        initializeBatle(enemyPokeStats: &enemyPokeStats, yourPokeStats: &yourPokeStats, enemypoke: enemypoke, mypoke: mypoke, level: Float(level))
        
        // LOAD SPRITES SET LABELS
        enemyHPLabel.text = pokemon!.capitalized + ": " + String(describing: enemyPokeStats["hp"]!) + " HP"
        yourHPLabel.text = mypoke.name!.capitalized + ": " + String(describing: yourPokeStats["hp"]!) + " HP"
        fetch_sprite(name: pokemon!, destination: enemyPokemon)
        fetch_sprite(name: (mypoke.name?.lowercased())!, destination: yourPokemon, back: true)
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func moveButtonPress(_ sender: UIButton) {
        if sender.tag < moves.count {
            let selectedMove = fetchMove(name: moves[sender.tag])
            let randint = Int(arc4random_uniform(UInt32(pokemonMoveList[(pokemon?.capitalized)!]!.count)))
            let enemySelectedMove = pokemonMoveList[(pokemon?.capitalized)!]![randint]
            let enemyMove = fetchMove(name: enemySelectedMove)
//            print(selectedMove.name!)
//            print(selectedMove.type!)
//            print(enemyMove.name!)
            
            let speed = yourPokeStats["speed"] as! Int
            let enemyspeed = enemyPokeStats["speed"] as! Int
            
            let mult = calculateMultiplier(move: selectedMove, target: enemypoke)
            let mult2 = calculateMultiplier(move: enemyMove, target: fetchAnyPokemon(name: mypoke.name!.lowercased()))

            
            yourPokemonLog.text = mypoke.name!.capitalized + " used " + selectedMove.name!
            enemyPokemonLog.text = enemypoke.name!.capitalized + " used " + enemyMove.name!
            
            logBattle(yourPokemonLog: yourPokemonLog!, enemyPokemonLog: enemyPokemonLog!, mult: mult, mult2: mult2)
            
            
            
            
            
            if( speed  >= enemyspeed){
                let temp = yourPokemonLog.text!
                yourPokemonLog.text = enemyPokemonLog.text!
                enemyPokemonLog.text = temp
                //Your Pokemon Attacks

                let atk = selectedMove.special ? Double(String(describing:yourPokeStats["spatk"]!)) : Double(String(describing: yourPokeStats["atk"]!))
                let def = selectedMove.special ? Double(String(describing:enemyPokeStats["spdef"]!)) : Double(String(describing: enemyPokeStats["def"]!))

                
             
                let damage = ((2 * Double(mypoke.level)) / 5) + 2
                let power = damage * Double(selectedMove.power) * atk! / def!
                var stab = 1.0
                if (selectedMove.type == mypoke.type1 || selectedMove.type == mypoke.type2){
                    stab = 1.5
                }
                let finalDmg = ((power / 50) + 2) * stab * mult
                var temphp = enemyPokeStats["hp"] as! Int
                enemyPokeStats["hp"] = temphp - Int(finalDmg)
                temphp = enemyPokeStats["hp"] as! Int
                if(temphp > 0)
                {
                    //Enemy Pokemon Attacks
                    
                    
                    let atk2 = selectedMove.special ? Double(String(describing:enemyPokeStats["spatk"]!)) : Double(String(describing: enemyPokeStats["atk"]!))
                    let def2 = selectedMove.special ? Double(String(describing:yourPokeStats["spdef"]!)) : Double(String(describing: yourPokeStats["def"]!))
                    
                    let damage2 = ((2 * Double(level!)) / 5) + 2
                    let power2 = damage2 * Double(enemyMove.power) * atk2! / def2!
                    var stab2 = 1.0
                    if (enemyMove.type == enemypoke.type1 || enemyMove.type == enemypoke.type2){
                        stab2 = 1.5
                    }
                    let finalDmg2 = ((power2 / 50) + 2) * stab2 * mult2
                    var temphp = yourPokeStats["hp"] as! Int
                    yourPokeStats["hp"] = temphp - Int(finalDmg2)
                    temphp = yourPokeStats["hp"] as! Int
                    if(temphp <= 0){
                        battleEndLose()
                    }
                   
                }
                else{
                    battleEnd()
                }
                enemyHPLabel.text = pokemon!.capitalized + ": " + String(describing: enemyPokeStats["hp"]!) + " HP"
                yourHPLabel.text = mypoke.name!.capitalized + ": " + String(describing: yourPokeStats["hp"]!) + " HP"

                
            }
            else{
                
                //Enemy Pokemon Attacks
                
                let atk2 = selectedMove.special ? Double(String(describing:enemyPokeStats["spatk"]!)) : Double(String(describing: enemyPokeStats["atk"]!))
                let def2 = selectedMove.special ? Double(String(describing:yourPokeStats["spdef"]!)) : Double(String(describing: yourPokeStats["def"]!))
                
                let damage2 = ((2 * Double(level!)) / 5) + 2
                let power2 = damage2 * Double(enemyMove.power) * atk2! / def2!
                var stab2 = 1.0
                if (enemyMove.type == enemypoke.type1 || enemyMove.type == enemypoke.type2){
                    stab2 = 1.5
                }
                let finalDmg2 = ((power2 / 50) + 2) * stab2 * mult2
                var temphp = yourPokeStats["hp"] as! Int
                yourPokeStats["hp"] = temphp - Int(finalDmg2)
                temphp = yourPokeStats["hp"] as! Int
                if(temphp > 0){
                    //Your Pokemon Attacks
                    let atk = selectedMove.special ? Double(String(describing:yourPokeStats["spatk"]!)) : Double(String(describing: yourPokeStats["atk"]!))
                    let def = selectedMove.special ? Double(String(describing:enemyPokeStats["spdef"]!)) : Double(String(describing: enemyPokeStats["def"]!))
                    
                    
                    
                    let damage = ((2 * Double(mypoke.level)) / 5) + 2
                    let power = damage * Double(selectedMove.power) * atk! / def!
                    var stab = 1.0
                    if (selectedMove.type == mypoke.type1 || selectedMove.type == mypoke.type2){
                        stab = 1.5
                    }
                    let finalDmg = ((power / 50) + 2) * stab * mult
                    
                    var temphp = enemyPokeStats["hp"] as! Int
                    enemyPokeStats["hp"] = temphp - Int(finalDmg)
                    temphp = enemyPokeStats["hp"] as! Int
                    if(temphp <= 0){
                        battleEnd()
                    }
                }
                else{
                    battleEndLose()
                }
                
                enemyHPLabel.text = pokemon!.capitalized + ": " + String(describing: enemyPokeStats["hp"]!) + " HP"
                yourHPLabel.text = mypoke.name!.capitalized + ": " + String(describing: yourPokeStats["hp"]!) + " HP"
            }
        }
        
        
        
        
    }
    
    func battleEnd() {

        performSegue(withIdentifier: "postBattle", sender: "win")
        
    }
    
    func battleEndLose(){
        performSegue(withIdentifier: "postBattle", sender: "lose")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.enemyPokemon.alpha = 1.0
            self.yourPokemon.alpha = 1.0
        })
        
    }
    @IBAction func FleeButtonPressed(_ sender: UIButton)
    {
        performSegue(withIdentifier: "unwindtohome", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*         delegate?.fightPressed(by: self, expvalue: 0, moneyvalue: moneyvalue, playerexpvalue: playerexpvalue) */

  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sent = sender as? String{
            if(sent == "win" || sent == "lose")
            {
                if(sent == "win"){
                     let destination = segue.destination as! PostBattleViewController
                    mypoke.exp += Int16(expvalues[pokemon!.capitalized]!)
                    if(mypoke.exp >= 100){
                        mypoke.exp = 0
                        mypoke.level += 1
                        destination.pokelevelup = true
                        destination.pokemon = mypoke
                    }
                    else{
                        destination.pokelevelup = false
                    }
                    
                    
                    user.exp += Int16(expvalues[pokemon!.capitalized]!)
                    if(user.exp > 100){
                        user.exp = 0
                        user.level += 1
                        user.pokebucks += 1
                        destination.levelup = true
                        user.stamina = 50 + user.level * 5
                    }
                    else{
                        destination.levelup = false
                    }
                    user.money += Int16(moneyvalues[pokemon!.capitalized]!)
                    destination.titletext = "Victory!"
                    destination.exp = expvalues[pokemon!.capitalized]!
                    destination.money = Int(moneyvalues[pokemon!.capitalized]!)
                    appDelegate.saveContext()
                }
                
                else if (sent == "lose"){
                    let destination = segue.destination as! PostBattleViewController
                    destination.levelup = false
                    destination.titletext = "Defeat..."
                    destination.exp = 0
                    destination.money = 0
                }
            }
        }

    }


}


func initializeBatle( enemyPokeStats: inout [String : Any],  yourPokeStats: inout [String: Any], enemypoke: AllPokemon, mypoke: Pokemon, level: Float){
    
    enemyPokeStats["hp"] = Int((((Float(enemypoke.hp) + 100) * level) / 100 + 10))
    enemyPokeStats["atk"] = Int((((Float(enemypoke.atk) + 100) * level)  / 100 + 5))
    enemyPokeStats["def"] = Int((((Float(enemypoke.def) + 100) * level)  / 100 + 5 ))
    enemyPokeStats["spatk"] = Int((((Float(enemypoke.spatk) + 100) * level)  / 100 + 5 ))
    enemyPokeStats["spdef"] = Int((((Float(enemypoke.spdef) + 100) * level) / 100 + 5 ))
    enemyPokeStats["speed"] = Int((((Float(enemypoke.speed) + 100) * level) / 100 + 5 ))
    enemyPokeStats["type1"] = enemypoke.type1
    if let type2 = enemypoke.type2{
        enemyPokeStats["type2"] = type2
    }
    
    
    //SET YOUR POKEMON STATS
    let level2 = Float(mypoke.level)
    yourPokeStats["hp"] = Int((((Float(mypoke.hp) + 100) * level2) / 100 + 10))
    yourPokeStats["atk"] = Int((((Float(mypoke.atk) + 100) * level2)  / 100 + 5))
    yourPokeStats["def"] = Int((((Float(mypoke.def) + 100) * level2)  / 100 + 5 ))
    yourPokeStats["spatk"] = Int((((Float(mypoke.spatk) + 100) * level2)  / 100 + 5 ))
    yourPokeStats["spdef"] = Int((((Float(mypoke.spdef) + 100) * level2) / 100 + 5 ))
    yourPokeStats["speed"] = Int((((Float(mypoke.speed) + 100) * level2) / 100 + 5 ))
    yourPokeStats["type1"] = mypoke.type1
    if let type2 = mypoke.type2{
        yourPokeStats["type2"] = type2
    }
    print(enemyPokeStats)
    print(yourPokeStats)
}

func calculateMultiplier(move: Move, target: AllPokemon) -> Double{
    var multiplier = 1.0
    var adv = [""]
    var disadv = [""]
    var types = [String]()
    types.append(target.type1!)
    if target.type2 != nil{
        types.append(target.type2!)
    }
    for type in types{
       
        print(type)
        let typeCalcs = multipliers[move.type!]! as NSDictionary
        adv = typeCalcs["adv"]! as! [String]
        print(adv)
        disadv = typeCalcs["disadv"]! as! [String]
        if let immune = typeCalcs["immune"] as? String{
            multiplier = multiplier * quickCalc(adv: adv, disadv: disadv, type: type, multiplier: multiplier, immune: immune)
        }
        else{
             multiplier = multiplier * quickCalc(adv: adv, disadv: disadv, type: type, multiplier: multiplier)
        }
        
    }
    return multiplier
        

}

func quickCalc(adv: [String], disadv: [String], type: String, multiplier: Double, immune: String = "") -> Double{
    var temp = multiplier
    if adv.contains(type) {
        temp =  2
    }
    else if disadv.contains(type) {
        temp =  0.5
    }
    if immune == type{
        return 0
    }
    return temp
}


func logBattle(yourPokemonLog: UILabel, enemyPokemonLog: UILabel, mult: Double, mult2: Double){
    if(mult > 1){
        yourPokemonLog.text = yourPokemonLog.text! + ", it was super effective!"
    }
    else if(mult < 1){
        yourPokemonLog.text = yourPokemonLog.text!  + ", it was not very effective..."
    }
    else if(mult == 0){
        yourPokemonLog.text = yourPokemonLog.text!  + "... but it had no effect"
    }
    else{
        yourPokemonLog.text = yourPokemonLog.text!  + "."
    }
    
    if(mult2 > 1){
        enemyPokemonLog.text = enemyPokemonLog.text! + " it was super effective!"
    }
    else if(mult2 == 0){
        enemyPokemonLog.text = enemyPokemonLog.text!  + "  ... but it had no effect"
    }
    else if(mult2 < 1){
        enemyPokemonLog.text = enemyPokemonLog.text!  + " it was not very effective..."
    }
    else{
        enemyPokemonLog.text = enemyPokemonLog.text!  + "."
    }
}

func setMultipliers(){
    multipliers["ice"] = ["adv" : ["grass", "ground", "flying", "dragon"], "disadv" : ["fire", "water", "ice", "steel"]]
    multipliers["fighting"] = ["adv" : ["normal", "ice", "rock", "dark", "steel"], "disadv" : ["poison", "flying", "psychic", "bug", "fairy"], "immune" : "ghost"]
    multipliers["poison"] = ["adv" : ["grass", "fairy"], "disadv" : ["poison", "ground", "dragon", "rock", "ghost"], "immune" : "steel"]
    multipliers["ground"] = ["adv" : ["fire", "electric", "poison", "rock", "steel"], "disadv" : ["grass", "bug"]]
    multipliers["flying"] = ["adv" : ["grass", "fighting", "bug"], "disadv" : ["electric", "rock", "steel"]]
    multipliers["psychic"] = ["adv" : [ "fighting", "poison"], "disadv" : ["psychic", "steel"], "immune" : "dark"]
    multipliers["bug"] = ["adv" : ["grass", "psychic"], "disadv" : ["]fire", "fighting", "poison", "flying", "ghost", "steel", "fairy"]]
    multipliers["rock"] = ["adv" : ["fire", "ice", "flying", "bug"], "disadv" : ["fighting", "ground", "steel"]]
    multipliers["ghost"] = ["adv" : ["psychic", "ghost"],  "disadv" : ["dark"], "immune" : "normal"]
    multipliers["dragon"] = ["adv" : ["dragon"],  "disadv" : ["steel"], "immune" : "fairy"]
    multipliers["dark"] = ["adv" : ["psychic", "ghost"],  "disadv" : ["fighting", "dark", "fairy"]]
    multipliers["steel"] = ["adv" : ["ice", "rock", "fairy"],  "disadv" : ["fire", "water", "electric", "steel"]]
    multipliers["fairy"] = ["adv" : ["fighting", "dragon", "dark"],  "disadv" : ["fire", "poison", "steel"]]
}





