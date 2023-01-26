//
//  PersonalDataFilter.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import Foundation
import UIKit

protocol FilterEntry {
    var filterString: String { get }
}

class AutoCompleteFilter<PersonalData: FilterEntry> {
    
    enum FilterType {
        case contains, startsWith
        
        func predicate(filterString: String) -> NSPredicate {
            switch self {
            case .contains:
                return NSPredicate(format: "SELF CONTAINS[cd] %@", filterString)
                
            case .startsWith:
                 return NSPredicate(format: "SELF BEGINSWITH[cd] %@", filterString)
            }
        }
    }
    
    var fullEntryList: [PersonalData]
    private(set) var filteredEntryList: [PersonalData] = []
    
    init(fullEntryList: [PersonalData]) {
        self.fullEntryList = fullEntryList
    }
    
    func filter(by type: FilterType, filterString: String?) {
        guard !fullEntryList.isEmpty else { return }
        
        if let filterString = filterString, !filterString.isEmpty {
            filteredEntryList = fullEntryList.filter { type.predicate(filterString: filterString).evaluate(with: $0.filterString) }
        } else {
           filteredEntryList = fullEntryList
        }
    }
}
