//
//  FetchSprite.swift
//  Pokemon
//
//  Created by Peter Lin on 3/27/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData

func fetch_sprite(name: String, destination: UIImageView, back: Bool = false){
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPokemon")
    
    request.predicate = NSPredicate(format: "name = %@", name.lowercased())
    do {
        let result = try managedObjectContext.fetch(request)
        var allpokemon = result as! [AllPokemon]
        print(name)
       
        let pokesprite =  back ? allpokemon[0].back_sprite : allpokemon[0].front_sprite
        
        let urlString = pokesprite
        let url = URL(string: urlString!)
    
    

        URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    print("Failed fetching image:", error as Any)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("Not a proper HTTPURLResponse or statusCode")
                    return
                }
                
                DispatchQueue.main.async {
                    destination.image = UIImage(data: data!)
                }
                }.resume()
        }
    catch {
            print( error )
        }
}

func fetchAnyPokemon(name: String) -> AllPokemon {
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AllPokemon")
    var allpokemon: [AllPokemon] = []
    request.predicate = NSPredicate(format: "name = %@", name.lowercased())
    do {
        let result = try managedObjectContext.fetch(request)
        allpokemon = result as! [AllPokemon]
        

    }
    catch {
        print( error )
    }
    return allpokemon[0]
}

func fetchUser() -> User
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
    var user = User()
    do {
        let result = try managedObjectContext.fetch(request)
        var allUsers = result as! [User]
        user = allUsers[0]
        
    } catch {
        print( error )
    }
    return user
}

func fetchMyPokemon() -> Pokemon
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    var poke = Pokemon()
    // FETCH FROM MY LIST OF POKEMON
    let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
    request1.predicate = NSPredicate(format: "selected = true")
    do {
        let result = try managedObjectContext.fetch(request1)
        var allpokemon = result as! [Pokemon]
        poke = allpokemon[0]
    } catch {
        print( error )
    }
    return poke
    
}


func fetchAllMyPokemon() -> [Pokemon]
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var allpokemon = [Pokemon]()
    // FETCH FROM MY LIST OF POKEMON
    let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")
    do {
        let result = try managedObjectContext.fetch(request1)
        allpokemon = result as! [Pokemon]

    } catch {
        print( error )
    }
    return allpokemon
    
}

func releasePokemon(){
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var poke = Pokemon()
    let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "Pokemon")

    do {
        let result = try managedObjectContext.fetch(request1)
        var allpokemon = result as! [Pokemon]
        poke = allpokemon[0]
    } catch {
        print( error )
    }

    managedObjectContext.delete(poke)
    appDelegate.saveContext()
    
}

func fetchType(name: String, destination: UIImageView){
    let lowername = name.lowercased()
    switch lowername {
    case "grass":
        destination.image = #imageLiteral(resourceName: "grass")
    case "fire":
        destination.image = #imageLiteral(resourceName: "fire")
    case "water":
        destination.image = #imageLiteral(resourceName: "water")
    case "poison":
        destination.image = #imageLiteral(resourceName: "poison")
    default:
        destination.image = nil
    }
    
}

func rollNewPokemon(name: String, level: Int?) -> [String]{
    let session = URLSession.shared
    let url = URL(string: "https://pokeapi.co/api/v2/pokemon/" + name.lowercased())
    let request = URLRequest(url: url!)
    var moves = [String]()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    if let currentLevel = level{
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    print("getting")
                    // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        let movelist = jsonResult["moves"] as! NSArray
                        for i in 0..<movelist.count{
                            let move = movelist[i] as! NSDictionary
                            let movedict = move["move"] as! NSDictionary
                            //print(movedict["name"])
                            
                            let versiondetails = move["version_group_details"] as! NSArray
                            
                            let detail = versiondetails[versiondetails.count-1] as! NSDictionary
                            let levelLearnedAt = detail["level_learned_at"] as! Int
                            print(levelLearnedAt, currentLevel)
                            if(levelLearnedAt == currentLevel){
                                print("levelmatch")
                                let method = detail["move_learn_method"] as! NSDictionary
                                if let methodname = method["name"] as? String{
                                    if methodname == "level-up"{
                                        var movename = movedict["name"] as! String
                                        movename = movename.replacingOccurrences(of: "-", with: " ")
                                        var poke = fetchMyPokemon()
                                        if(!poke.moves?.contains(movename.capitalized)){
                                            poke.moves?.append(movename.capitalized)
                                            appDelegate.saveContext()
                                        }
                                       
                                        

                                    }
                                }
                            }
                        }
                        
                    }
                    
                }
                catch{
                    print("error")
                }
            }
        }.resume()
        
    }
    else{
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    print("getting")
                    // Try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        let movelist = jsonResult["moves"] as! NSArray
                        for i in 0..<movelist.count{
                            let move = movelist[i] as! NSDictionary
                            let movedict = move["move"] as! NSDictionary
                            //print(movedict["name"])
                            
                            let versiondetails = move["version_group_details"] as! NSArray
                            
                            let detail = versiondetails[versiondetails.count-1] as! NSDictionary
                            let levelLearnedAt = detail["level_learned_at"] as! Int
                            if(levelLearnedAt < 5){
                                let method = detail["move_learn_method"] as! NSDictionary
                                if let methodname = method["name"] as? String{
                                    if methodname == "level-up"{
                                        var movename = movedict["name"] as! String
                                        movename = movename.replacingOccurrences(of: "-", with: " ")
                                        moves.append(movename.capitalized)
                                    }
                                }
                            }
                        }
                        
                    }
                    
                    let new = NSEntityDescription.insertNewObject(forEntityName: "Pokemon", into: managedObjectContext) as! Pokemon
                    let newPoke = fetchAnyPokemon(name: name)
                    
                    new.type1 = newPoke.type1
                    if let type2 = newPoke.type2 {
                        new.type2 = type2
                    }
                    new.level = 5
                    new.name = newPoke.name
                    new.moves = moves
                    new.atk = Int16(newPoke.atk)
                    new.spatk = Int16(newPoke.spatk)
                    new.def = Int16(newPoke.def)
                    new.spdef = Int16(newPoke.spdef)
                    new.speed = Int16(newPoke.speed)
                    new.hp = Int16(newPoke.hp)
                    appDelegate.saveContext()
                    
                    
                }
                catch{
                    print("error")
                }
            }
            
        }
        task.resume()
       
    }
    return moves
}

func fetchMove(name: String) -> Move
{

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Move")
    var moves: [Move] = []
    request.predicate = NSPredicate(format: "name = %@", name)
    do {
        let result = try managedObjectContext.fetch(request)
    
        moves = result as! [Move]
        
        
        
        
    }
    catch {
        print( error )
    }
    return moves[0]
    
}
