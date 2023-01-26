//
//  PersonListPresenter.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import Foundation
import UIKit

protocol BasePresenterProtocol: AnyObject {
    func onViewDidLoad()
}

protocol PersonalDataListPresenterProtocol: BasePresenterProtocol {
    var dataSource: [PersonalData] { get }
    var isSearching: Bool { get set }
    
    func onViewDidLoad()
    func searchPerson(searchText: String)
    func showData()
}

class PersonalDataListPresenter {
    private weak var controller: PersonalDataListControllerProtocol?
    private var dbManager: PersonalDataDBManagerProtocol
    private let formatter : PersonalDataListFormatterProtocol
    private let dataFetcher: DataFetcherProtocol
    private let dataParser: PersonalDataParser
    private let dataFilter: AutoCompleteFilter<PersonalData>
    
    var isSearching: Bool
    var isJsonParsed: Bool?
    
    var dataSource: [PersonalData] = []
    var filteredData: [PersonalData] = []
    
    init(controller: PersonalDataListControllerProtocol,
         dbManager: PersonalDataDBManagerProtocol,
         formatter: PersonalDataListFormatterProtocol = PersonalDataListFormatter(),
         dataFetcher: DataFetcherProtocol,
         dataParser: PersonalDataParser,
         dataFilter: AutoCompleteFilter<PersonalData>) {
        self.controller = controller
        self.dbManager = dbManager
        self.formatter = formatter
        self.dataFetcher = dataFetcher
        self.dataParser = dataParser
        self.dataFilter = dataFilter
        self.isSearching = false
        
        self.controller?.presenter = self
    }
}

extension PersonalDataListPresenter: PersonalDataListPresenterProtocol {
    func fetchDataFromJson() {
        let jsonData = self.dataFetcher.readLocalJSONFile(forName: "Generated")
        if let data = jsonData {
            if let personalDataJsonObj = self.dataParser.parse(jsonData: data) {
                personalDataJsonObj.forEach { self.dbManager.create(with: $0) }
                self.dataSource = self.dbManager.fetch()
            }
        }
        filteredData = dataSource
    }
    
    func fetchDataFromDB() {
        dataSource = dbManager.fetch()
        filteredData = dataSource
    }
    
    func showData() {
        if isSearching {
            controller?.show(rows: formatter.convert(personalData: filteredData))
        } else {
            controller?.show(rows: formatter.convert(personalData: dataSource))
        }
    }
    
    func onViewDidLoad() {
        let isDataAlreadyFetched = UserDefaults.standard.bool(forKey: "fetchDataFromJson")
        if isDataAlreadyFetched {
            fetchDataFromDB()
        } else {
            fetchDataFromJson()
            isJsonParsed = true
            UserDefaults.standard.set(isJsonParsed, forKey: "fetchDataFromJson")
        }
        showData()
    }
    
    func searchPerson(searchText: String) {
        dataFilter.fullEntryList = dataSource
        dataFilter.filter(by: .contains, filterString: searchText)
        
        filteredData = dataFilter.filteredEntryList
        showData()
    }
}
