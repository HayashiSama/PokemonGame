//
//  EventViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/26/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    @IBOutlet weak var wildLabel: UILabel!
    var area: String?
    var pokemonlist = [String]()
    var delegate: EventDelegate?
    
    var fulllist = ["Area Name": "", "Pokemon": []] as [String : Any]

    
    @IBOutlet weak var locationPicture: UIImageView!
    @IBOutlet weak var pokemonImage: UIImageView!
    var selectedPokemon: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let an = area{
            fulllist["Area Name"] = an
        }
        if area == "Viridian Forest"{
             fulllist["Pokemon"] = ["Weedle", "Caterpie", "Pikachu"]
            locationPicture.image = #imageLiteral(resourceName: "ViridianForest")
        }
        else if area == "Mt Moon" {
            fulllist["Pokemon"] = ["Geodude", "Zubat", "Jigglypuff"]
            locationPicture.image = #imageLiteral(resourceName: "mt_moon")
        }
        else if area == "Route 4" {
            fulllist["Pokemon"] = ["Pidgey", "Rattata", "Spearow"]
        }
        
        else if area == "Victory Road" {
            fulllist["Pokemon"] = ["Graveler", "Golbat", "Clefairy"]
        }
        
        
        //RNG GENERATE EVENT
        let random = arc4random_uniform(UInt32(100))
        pokemonlist = fulllist["Pokemon"] as! [String]
        if random < 45 {
            selectedPokemon = pokemonlist[0]
        }
        else if random < 90 {
            selectedPokemon = pokemonlist[1]
        }
        else{
            selectedPokemon = pokemonlist[2]
        }
        wildLabel.text = "Wild " + selectedPokemon! + " Appeared!"
        fetch_sprite(name: selectedPokemon!.lowercased(), destination: pokemonImage)
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fightButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "battle", sender: sender)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! BattleViewController
        destination.area = area
        destination.pokemon = selectedPokemon
        destination.delegate = delegate
        
    }
    
    @IBAction func runButtonPressed(_ sender: UIButton) {
        delegate?.runPressed(by: self)
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

protocol EventDelegate: class {
    func fightPressed(by controller: EventViewController, expvalue: Int, moneyvalue: Int, playerexpvalue: Int)
    func runPressed(by controller: EventViewController)
    
}
