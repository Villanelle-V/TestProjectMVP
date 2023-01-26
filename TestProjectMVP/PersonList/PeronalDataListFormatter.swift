//
//  PeronalDataListFormatter.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import Foundation

protocol PersonalDataListFormatterProtocol {
    func convert(personalData: [PersonalData]) -> [PersonalDataUIModel]
}

class PersonalDataListFormatter: PersonalDataListFormatterProtocol {
    func convert(personalData: [PersonalData]) -> [PersonalDataUIModel] {
        return personalData.map {
            PersonalDataUIModel(name: $0.name, phone: $0.phone, email: $0.email, address: $0.address)
        }
    }
}
