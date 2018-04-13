//
//  PostBattleViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/30/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData

class PostBattleViewController: UIViewController {

    var exp: Int!
    var money: Int!
    var levelup: Bool!
    var pokelevelup: Bool!
    var titletext: String!
    var pokemon: Pokemon?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var levelUpLabel: UILabel!
    @IBOutlet weak var pokemonLevelUpLabel: UILabel!
    
    var user = User()
    

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAll()

        titleLabel.text = titletext
        expLabel.text = "Exp: " + String(describing: exp!)
        moneyLabel.text = "Money: " + String(describing: money!)
        if (exp! != 0){
            moneyLabel.text = moneyLabel.text! +  ". You now have " + String(describing: user.money)
        }
        
        if levelup {
            levelUpLabel.text = "You leveled up!, Max stamina increased: " + String(describing: user.stamina) + ", Gained 1 PokeBuck"
        }
        
        if pokelevelup {
            

            
            DispatchQueue.main.async{
                self.pokemonLevelUpLabel.text = self.pokemon!.name! + " leveled up to " + String(describing: self.pokemon!.level)
                var moves = rollNewPokemon(name: self.pokemon!.name!, level: Int(self.pokemon!.level))
                print(moves)
                var pok = fetchMyPokemon()
                if(pok.moves!.count > 4 ){
                    self.pokemonLevelUpLabel.text = self.pokemonLevelUpLabel.text! +  ", it is trying to learn " + pok.moves![4] + " select a move to be forgotten, or click Back to Home to not learn the skill"
                }
            }

        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goHome(_ sender: UIButton) {
        performSegue(withIdentifier: "goHome", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchAll()
    {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try managedObjectContext.fetch(request)
            var allUsers = result as! [User]
            user = allUsers[0]
            
        } catch {
            print( error )
        }
    }
}
