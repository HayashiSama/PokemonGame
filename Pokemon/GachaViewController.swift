//
//  GachaViewController.swift
//  Pokemon
//
//  Created by Peter Lin on 3/27/18.
//  Copyright © 2018 Peter Lin. All rights reserved.
//

import UIKit

class GachaViewController: UIViewController {
    var user = User()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var pokeball: UIImageView!
    @IBAction func drawButtonPressed(_ sender: UIButton) {
        if(user.pokebucks > 0)
        {
            //user.pokebucks -= 1
            appDelegate.saveContext()
            performSegue(withIdentifier: "gachaRoll", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        user = fetchUser()
        pokeball.alpha = 0
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1.5, animations: {
            self.pokeball.alpha = 1.0
            
        })
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
