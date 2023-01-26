//
//  PersonalDataCell.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import UIKit

class PersonalDataCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(with model: PersonalDataUIModel) {
        name.text = model.name
        address.text = model.address
        phone.text = model.phone
        email.text = model.email
    }
}
