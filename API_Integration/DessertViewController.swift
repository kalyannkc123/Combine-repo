//
//  DessertViewController.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/27/23.
//

import UIKit
import Combine

class DessertViewController: UIViewController {
    
    var meals: [Meal] = []
    var allMeals: [Meal] = []
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureView()
        configureTableView()
        getMeals()
    }
    
    private func configureView() {
        view.backgroundColor = .systemBackground
    }
    
    private func configureNavigationBar() {
        title = "Desserts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Set up the search controller
        searchController.searchBar.placeholder = "Search"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DessertTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifiers.dessertTableViewCell)
    }
    
    private func getMeals() {
        DessertViewModel()
            .getMeals(for: .dessert)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] meals in
                self?.meals = meals
                self?.allMeals = meals
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension DessertViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.dessertTableViewCell, for: indexPath) as? DessertTableViewCell else {
            return UITableViewCell()
        }
        cell.setUp(with: meals[indexPath.row])
        return cell
    }
}

extension DessertViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = IngredientViewController(with: meals[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension DessertViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterMeals(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        filterMeals(with: "")
        searchBar.resignFirstResponder()
    }
    
    private func filterMeals(with searchText: String) {
        if searchText.isEmpty {
            meals = allMeals
        } else {
            meals = allMeals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
}
