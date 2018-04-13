//
//  PullResultViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/27/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit

class PullResultViewController: UIViewController {


    
    @IBOutlet weak var pokeImage: UIImageView!
    var common = ["Weedle", "Caterpie", "Pidgey", "Rattata", "Spearow", "Doduo", "Grimer", "Tentacool", "Zubat", "Geodude", "Oddish", "Magikarp", "Bellsprout"]
    
    var uncommon = ["Shellder", "Staryu", "Seel", "Ponyta", "Clefairy", "Jigglypuff", "Sandshrew", "Machop", "Paras", "Venonat", "Diglett", "Meowth", "Mankey", " Goldeen", "Slowpoke", "Voltorb", "Doduo", "Onix", "Drowzee", "Krabby", "Exeggcute", "Koffing", "Rhyhorn", "Goldeen"]
    
    var rare = ["Pikachu", "Vulpix", "Growlithe", "Poliwag", "Abra", "Magnemite", "Gastly", "Cubone", "Lickitung", "Hitmonlee", "Hitmonchan", "Tangela", "Horsea", "Tauros", "Jynx"]
    
    var superrare = ["Chansey", "Kangaskhan", "Scyther", "Pinsir",  "Electabuzz", "Magmar", "Dratini", "Lapras", "Ditto", "Eevee", "Omanyte", "Kabuto", "Aerodactyl", "Snorlax"]
    
    var legendary = ["Zapdos", "Articuno", "Moltres", "Mewtwo"]
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var rarity: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pokeImage.alpha = 0
        var selectedPokemon = ""
        let randomnum = arc4random_uniform(UInt32(100)) + 1
        
        if randomnum == 1 {
            let newrand = Int(arc4random_uniform(UInt32(legendary.count)))
            selectedPokemon = legendary[newrand]
            rarity.image = #imageLiteral(resourceName: "star-png-png-888")
            
        }
        else if randomnum < 8 {
            let newrand = Int(arc4random_uniform(UInt32(superrare.count)))
            selectedPokemon = superrare[newrand]
            rarity.image = nil
        }
        
        else if randomnum < 21{
            let newrand = Int(arc4random_uniform(UInt32(rare.count)))
            selectedPokemon = rare[newrand]
            rarity.image = nil
        }
            
        else if randomnum < 51{
            let newrand = Int(arc4random_uniform(UInt32(uncommon.count)))
            selectedPokemon = uncommon[newrand]
            rarity.image = nil
        }
        else {
            let newrand = Int(arc4random_uniform(UInt32(common.count)))
            selectedPokemon = common[newrand]
        }
        confirmButton.setTitle("You got " + selectedPokemon + " !", for: .normal)
        fetch_sprite(name: selectedPokemon.lowercased(), destination: pokeImage)
        var moveset = rollNewPokemon(name: selectedPokemon, level: nil)
        if(moveset.count < 1){
            print("error")
        }
        


        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.5, animations: {
            self.pokeImage.alpha = 1.0

        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
   
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindGacha", sender: self)
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
