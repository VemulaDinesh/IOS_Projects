//
//  Newviewcontroller.swift
//  Feedback form
//
//  Created by Vemula Dinesh on 17/01/24.
//

import UIKit
class Newviewcontroller: UIViewController{
@IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  @IBOutlet weak var ratingLabel: UILabel!
  var name: String?
  var phone: String?
  var email: String?
  var rating: String?
  override func viewDidLoad() {
    super.viewDidLoad()
    nameLabel.text = "Name: \(name ?? "")"
    phoneLabel.text = "Phone: \(phone ?? "")"
    emailLabel.text = "Email: \(email ?? "")"
    ratingLabel.text = "Reviw: \(rating ?? "")"
      nameLabel.adjustsFontSizeToFitWidth = true
      phoneLabel.adjustsFontSizeToFitWidth = true
      emailLabel.adjustsFontSizeToFitWidth = true
      ratingLabel.adjustsFontSizeToFitWidth = true
  }
}
