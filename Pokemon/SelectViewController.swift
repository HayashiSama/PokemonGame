//
//  SelectViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/30/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit
import CoreData

class SelectViewController: UIViewController {


    var myPokemonList = [Pokemon]()
    
    @IBOutlet weak var activePokemon: UIImageView!
    


    
    @IBOutlet var Images: [UIImageView]!
    
    override func viewDidAppear(_ animated: Bool) {
        myPokemonList = fetchAllMyPokemon()
        
        fetch_sprite(name: fetchMyPokemon().name!, destination: activePokemon)
        
        for i in 0..<myPokemonList.count{
            fetch_sprite(name: myPokemonList[i].name!, destination: Images[i])
        }
    }


    @objc func connected(_ sender:AnyObject){
        print("you tap image number : \(sender.view.tag)")
        fetchMyPokemon().selected = false
        myPokemonList[sender.view.tag].selected = true
        viewDidLoad()
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        var i = 0
        for imageView in Images{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SelectViewController.connected(_:)))

            imageView.isUserInteractionEnabled = true
            imageView.tag = i
            i += 1
            imageView.addGestureRecognizer(tapGestureRecognizer)
            
            
        }

        
        
        myPokemonList = fetchAllMyPokemon()
        
        fetch_sprite(name: fetchMyPokemon().name!, destination: activePokemon)
    
        for i in 0..<myPokemonList.count{
            fetch_sprite(name: myPokemonList[i].name!, destination: Images[i])
        }
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
