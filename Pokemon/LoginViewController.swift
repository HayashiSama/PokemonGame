//
//  ViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/26/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData


class LoginViewController: UIViewController {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMultipliers()
        
        // Do any additional setup after loading the view, typically from a nib.
        //print(fetchAnyPokemon(name: "bulbasaur").type2! + " Type2" + fetchAnyPokemon(name: "weedle").type1!)
        //compileData(i: 98)
        //getMoves(i: 1)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {

        if(fetchAll() > 0){

            releasePokemon()
            //performSegue(withIdentifier: "hasAccount", sender: self)
        }
        else {
                print("hi2")
            performSegue(withIdentifier: "newUserSegue", sender: self)
        }


    }
    
    func fetchAll() -> Int
    {
        var pokemon = [Pokemon]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
        do {
            let result = try managedObjectContext.fetch(request)
            pokemon = result as! [Pokemon]
            
        } catch {
            print( error )
        }
    return pokemon.count

    }
    

    
    
    func compileData(i: Int)
    {
        if(i < 165){
            let session = URLSession.shared
            let url = URL(string: "https://pokeapi.co/api/v2/pokemon/" + String(i))
            let request = URLRequest(url: url!)
            let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                    do {
                        print("getting")
                        // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            
                            let new = NSEntityDescription.insertNewObject(forEntityName: "AllPokemon", into: self.managedObjectContext) as! AllPokemon
                            let sprites = jsonResult["sprites"] as! NSDictionary
                            let types = jsonResult["types"] as! NSArray
                            if(types.count > 1)
                            {
                                let type1 = types[0] as! NSDictionary
                                let type2 = types[1] as! NSDictionary

                                let type_1 = type1["type"] as! NSDictionary
                                let type_2 = type2["type"] as! NSDictionary
                                new.type1 = (type_2["name"] as! String)
                                new.type2 = (type_1["name"] as! String)
                                print(new.type1)
                                print(new.type2)
                            }
                            else{
                                let type1 = types[0] as! NSDictionary
                                let type_1 = type1["type"] as! NSDictionary
                                new.type1 = (type_1["name"] as! String)
                            }
                            
                            let stats = jsonResult["stats"] as! NSArray
                            

                            new.name = (jsonResult["name"] as! String)

                            new.front_sprite = String(describing: sprites["front_default"]!)
                            new.back_sprite = String(describing: sprites["back_default"]!)
                            let speed = stats[0] as! NSDictionary
                            let spdef = stats[1] as! NSDictionary
                            let spatk = stats[2] as! NSDictionary
                            let def = stats[3] as! NSDictionary
                            let atk = stats[4] as! NSDictionary
                            let hp = stats[5] as! NSDictionary
                            
                            new.speed = speed["base_stat"] as! Int32
                            new.spdef = spdef["base_stat"] as! Int32
                            new.spatk = spatk["base_stat"] as! Int32
                            new.def = def["base_stat"] as! Int32
                            new.atk = atk["base_stat"] as! Int32
                            new.hp = hp["base_stat"] as! Int32
                            print("adding" + new.name! + " HP" + String(new.hp))
                            
                            self.appDelegate.saveContext()
                            let nextPoke = i+1
                            DispatchQueue.main.async {
                                self.compileData(i: nextPoke)
                            }
                            
                            
                            
                            
                        }
                        
                    }
                        
                        
                    catch{
                        print("ERROR")
                        }
                    }
                }
            task.resume()
            
        }


    }
    
    
    func getMoves(i: Int)
    {
        if(i < 300){
            let session = URLSession.shared
            let url = URL(string: "https://pokeapi.co/api/v2/move/" + String(i))
            let request = URLRequest(url: url!)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        print("getting")
                        // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            
                       
                            let movenames = jsonResult["names"] as! NSArray
                          
                            for move in movenames {
                                let moveDict = move as! NSDictionary
                               
                                let moveLang = moveDict["language"] as! NSDictionary
                                
                                
                                if String(describing: moveLang["name"]!) == "en" {

                                    let movetype = jsonResult["type"] as! NSDictionary
                                    let damageClass = jsonResult["damage_class"] as! NSDictionary
                                    let damagetype = damageClass["name"] as! String
                                
                                    
                                    let new = NSEntityDescription.insertNewObject(forEntityName: "Move", into: self.managedObjectContext) as! Move
                                    
                                    new.name = (moveDict["name"]! as! String)
                                    if let power = jsonResult["power"]! as? Int16 {
                                        new.power = power
                                    }
                                    else{
                                        new.power = Int16(0)
                                    }
                                    
                                    if let accuracy = jsonResult["accuracy"]! as? Int16{
                                        new.accuracy = accuracy
                                    }
                                    else{
                                        new.accuracy = 0
                                    }
                                    
                                    new.type = (movetype["name"]! as! String)
                                    if(damagetype == "physical"){
                                        new.special = false
                                    }
                                    else{
                                        new.special = true
                                    }
                                    print(new.name!)
                                
                                    self.appDelegate.saveContext()
                                }
                                
                            }
                            

                            
                            
                            let j = i + 1
                            DispatchQueue.main.async {
                                self.getMoves(i: j)
                            }
                            
                            
                            
                            
                        }
                        
                    }
                        
                        
                    catch{
                        print("ERROR")
                    }
                }
            }
            task.resume()
            
        }
        
        
    }
    
        
        
//        var pokemon = [AllPokemon]()
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPokemon")
//        do {
//            let result = try managedObjectContext.fetch(request)
//            pokemon = result as! [Pokemon]
//
//        } catch {
//            print( error )
//        }
//        return pokemon.count
//
    
    
}

