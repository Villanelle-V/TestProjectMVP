//
//  DataFetcher.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import Foundation
import UIKit

protocol DataFetcherProtocol {
    func readLocalJSONFile(forName name: String) -> Data?
}

class DataFetcher: DataFetcherProtocol {
    func readLocalJSONFile(forName name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
}
