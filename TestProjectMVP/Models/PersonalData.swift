//
//  PersonalData.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import Foundation

struct PersonalData: Codable {
    let name: String
    let phone: String
    let email: String
    let address: String
}

extension PersonalData {
    init(with personalData: PersonalDataMO) {
        name = personalData.name
        phone = personalData.phone
        email = personalData.email
        address = personalData.address
    }
}

extension PersonalData: FilterEntry {
    var filterString: String {
        return name + phone + email + address
    }
}
