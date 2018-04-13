//
//  FirstPokemonViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/26/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData

class FirstPokemonViewController: UIViewController {
    
    var pokemonOptions = [0, 1, 2]
    var option = 0
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var sprite: UIImageView!
    @IBOutlet weak var firstType: UIImageView!
    @IBOutlet weak var secondType: UIImageView!
    
    @IBOutlet weak var firstMove: UILabel!
    @IBOutlet weak var secondMove: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(option == 0){
            pokemonName.text = "Bulbasaur"
            fetch_sprite(name: "bulbasaur", destination: sprite)

            sprite.alpha = 0
            fetchType(name: "grass", destination: firstType)
            fetchType(name: "poison", destination: secondType)
            firstMove.text = "Tackle"
            secondMove.text = "Vine Whip"
        }
        else if (option == 1) {
            pokemonName.text = "Charmander"
            fetch_sprite(name: "charmander", destination: sprite)
            sprite.alpha = 0
            fetchType(name: "fire", destination: firstType)
            secondType.image = nil
            firstMove.text = "Scratch"
            secondMove.text = "Ember"
            
        }
        else {
            pokemonName.text = "Squirtle"
            fetch_sprite(name: "squirtle", destination: sprite)
            sprite.alpha = 0
            fetchType(name: "water", destination: firstType)
            secondType.image = nil
            firstMove.text = "Tackle"
            secondMove.text = "Bubble"
        }
        viewDidAppear(true)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.sprite.alpha = 1.0
            })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        if option < 2{
            option += 1
        }
        else {
            option = 0
        }
        self.viewDidLoad()
    }
    
    @IBAction func chooseButton(_ sender: UIButton) {
        let newPokemon = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: managedObjectContext) as! Pokemon
        newPokemon.moves = []
        if(option == 0){
            newPokemon.name = "Bulbasaur"
            newPokemon.type1 = "grass"
            newPokemon.type2 = "poison"
            newPokemon.sprite = "1_normal"
            newPokemon.atk = 49
            newPokemon.hp = 45
            newPokemon.def = 49
            newPokemon.spatk = 65
            newPokemon.spdef = 65
            newPokemon.speed = 45
            newPokemon.moves!.append("Tackle")
            newPokemon.moves!.append("Vine Whip")
            
//            let moves = newPokemon.mutableSetValue(forKey: #keyPath(Pokemon.hasMoves))
//            let move = Move()
//            move.name = "Tackle"
//            move.power = 40
//            move.type = "Normal"
//
//            let move2 = Move()
//            move2.name = "Growl"
//            move.power = 0
//            move.type = "Normal"
//            moves.add(move)
//            moves.add(move2)
            
        }
        else if (option == 1) {
            newPokemon.name = "Charmander"
            newPokemon.type1 = "fire"
            newPokemon.sprite = "4_normal"

            newPokemon.hp = 39
            newPokemon.atk = 52
            newPokemon.def = 43
            newPokemon.spatk = 60
            newPokemon.spdef = 50
            newPokemon.speed = 65
            
            
            newPokemon.moves!.append("Scratch")
            newPokemon.moves!.append("Ember")
            
            
            
            
            
//            let moves = newPokemon.mutableSetValue(forKey: #keyPath(Pokemon.hasMoves))
//            let move = Move()
//            move.name = "Scratch"
//            move.power = 40
//            move.type = "Normal"
//
//            let move2 = Move()
//            move2.name = "Leer"
//            move.power = 0
//            move.type = "Normal"
//            moves.add(move)
//            moves.add(move2)
//
        }
        else {
            newPokemon.name = "Squirtle"
            newPokemon.type1 = "water"
            newPokemon.sprite = "7_normal"
            
            newPokemon.hp = 44
            newPokemon.atk = 48
            newPokemon.def = 65
            newPokemon.spatk = 50
            newPokemon.spdef = 64
            newPokemon.speed = 43
        
            newPokemon.moves!.append("Tackle")
            newPokemon.moves!.append("Bubble")
            
            
            
//            let moves = newPokemon.mutableSetValue(forKey: #keyPath(Pokemon.hasMoves))
//            let move = Move()
//            move.name = "Tackle"
//            move.power = 40
//            move.type = "Normal"
//
//            let move2 = Move()
//            move2.name = "Tail Whip"
//            move.power = 0
//            move.type = "Normal"
//            moves.add(move)
//            moves.add(move2)
        }
        newPokemon.exp = 0
        newPokemon.level = 5
        newPokemon.selected = true

        
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: managedObjectContext) as! User
        newUser.money = 0
        newUser.id = 1
        newUser.level = 0
        newUser.stamina = 50
        newUser.exp = 0
        newUser.pokebucks = 0
        
        
        appDelegate.saveContext()
        
        performSegue(withIdentifier: "createdFirst", sender: self)

    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
