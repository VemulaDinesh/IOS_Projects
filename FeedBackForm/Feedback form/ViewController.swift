//
//  ViewController.swift
//  Feedback form
//
//  Created by Vemula Dinesh on 16/01/24.
//

import UIKit

class ViewController: UIViewController {

   
    @IBOutlet weak var reviewfield: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var nametextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func button(_ sender: Any) {
        performSegue(withIdentifier: "showDetailsSegue", sender:self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "showDetailsSegue"{
            if let detailsViewController = segue.destination as? Newviewcontroller{
                detailsViewController.name = nametextfield.text
                detailsViewController.phone = phone.text
                detailsViewController.email = email.text
                detailsViewController.rating = reviewfield.text
            }
        }
    }
}

