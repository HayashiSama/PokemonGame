//
//  HomeViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/26/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController,  EventDelegate {

    

    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @IBOutlet weak var pokebucks: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var stamina: UILabel!
    @IBAction func unwindtohome(segue:UIStoryboardSegue) { }
    
    @IBOutlet var pokemonImages: [UIImageView]!
    var isNew = false
    var myPokemonList = [Pokemon]()

    
    //var delegate: EventDelegate?
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = fetchUser()
        myPokemonList = fetchAllMyPokemon()
        
        for i in 0..<myPokemonList.count {
            if(i < 6){
                fetch_sprite(name: (myPokemonList[i].name?.lowercased())!, destination: pokemonImages[i])
            }
        }
      
        pokebucks.text = "PokeBucks: " + String(user.pokebucks)
        level.text = "Level: " + String(user.level)
        money.text = "Money: " + String(user.money)
        stamina.text = "Stamina: " + String(user.stamina)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        user = fetchUser()
        myPokemonList = fetchAllMyPokemon()
        
        for i in 0..<myPokemonList.count {
            if(i < 6){
                if(i == 1){
                    print(myPokemonList[1].name)
                }
                fetch_sprite(name: (myPokemonList[i].name?.lowercased())!, destination: pokemonImages[i])
            }
        }
        pokebucks.text = "PokeBucks: " + String(user.pokebucks)
        level.text = "Level: " + String(user.level)
        money.text = "Money: " + String(user.money)
        stamina.text = "Stamina: " + String(user.stamina)

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doEvent(_ sender: UIButton) {
        if user.stamina >= costs[sender.tag]{
            performSegue(withIdentifier: "doEvent", sender: sender)
            user.stamina = user.stamina - Int16(costs[sender.tag])
            
            appDelegate.saveContext()
        }
        else{
            user.stamina += 10
            appDelegate.saveContext()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! EventViewController
        if let sentby = sender as? UIButton{
            if user.stamina >= costs[sentby.tag]
            {
                destination.area = locations[sentby.tag]
                destination.delegate = self
            }
        }
    }
    
    func fightPressed(by controller: EventViewController, expvalue: Int, moneyvalue: Int, playerexpvalue: Int) {
        user.exp += Int16(playerexpvalue)
        user.money += Int16(moneyvalue)
        dismiss(animated: true, completion: nil)
        appDelegate.saveContext()

    }
    
    func runPressed(by controller: EventViewController) {
        dismiss(animated: true, completion: nil)
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
