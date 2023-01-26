//
//  PersonListViewController.swift
//  TestProjectMVP
//
//  Created by Polina on 2022-12-08.
//

import UIKit

protocol PersonalDataListControllerProtocol: AnyObject {
    var presenter: PersonalDataListPresenterProtocol? { get set }
    
    func show(rows: [PersonalDataUIModel])
}

class PersonalDataListViewController: UIViewController {
    var presenter: PersonalDataListPresenterProtocol?
    let searchController = UISearchController(searchResultsController: nil)
    private var rows: [PersonalDataUIModel] = []
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

extension PersonalDataListViewController {
    func configureUI() {
        configureTableView()
        configureSearchBar()
        
        indicatorView.startAnimating()
        
        DispatchQueue.global(qos: .background).async {
            self.presenter?.onViewDidLoad()
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
            }
        }
    }
    func configureTableView() {
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: PersonalDataCell.className), bundle: nil), forCellReuseIdentifier: String(describing: PersonalDataCell.className))
        view.addSubview(tableView)
        view.addSubview(indicatorView)
    }
}
    
extension PersonalDataListViewController {
    func configureSearchBar() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        navigationItem.searchController = searchController
    }
}

extension PersonalDataListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PersonalDataCell.className), for: indexPath) as! PersonalDataCell
        cell.set(with: model)
        
        return cell
    }
}

extension PersonalDataListViewController: PersonalDataListControllerProtocol {
    func show(rows: [PersonalDataUIModel]) {
        self.rows = rows
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UISearch Bar methods
extension PersonalDataListViewController: UISearchControllerDelegate, UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchPerson(searchText: searchText)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        indicatorView.startAnimating()
        searchController.isActive = false
        presenter?.isSearching = false
        
        DispatchQueue.global().async {
            self.presenter?.showData()
            DispatchQueue.main.async {
                self.indicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchController.isActive = true
        presenter?.isSearching = true
    }
}
