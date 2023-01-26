//
//  PersonalDataParser.swift
//  TestProjectMVP
//
//  Created by Polina on 2023-01-26.
//

import Foundation

class PersonalDataParser {
    var model: [PersonalData] = []
    
    func parse(jsonData: Data) -> [PersonalData]? {
                do {
                    let decodedData = try JSONDecoder().decode([PersonalData].self, from: jsonData)
                    model = decodedData
                    return decodedData
                } catch {
                    print("error: \(error)")
                }
                return nil
    }
}
