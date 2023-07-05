//
//  IngredientViewController.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import UIKit
import Combine

class IngredientViewController: UIViewController {
    
    var mealID: Int?
    var ingredients: [Ingredient] = []
    private var cancellables = Set<AnyCancellable>()

    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private lazy var instructionsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Instructions"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 32)
        label.textColor = .label
        return label
    }()
    
    private lazy var instructionDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .label
        return label
    }()
    
    private lazy var ingredientsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        return tableView
    }()
    
    private var ingredientsTableViewHeightConstraint: NSLayoutConstraint?
    
    init(with mealID: Int) {
        super.init(nibName: nil, bundle: nil)
        self.mealID = mealID
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMealDetails()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupInstructions()
        setupIngredientsTableView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupInstructions() {
        contentView.addSubview(instructionsLabel)
        NSLayoutConstraint.activate([
            instructionsLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        contentView.addSubview(instructionDescription)
        NSLayoutConstraint.activate([
            instructionDescription.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 10),
            instructionDescription.leadingAnchor.constraint(equalTo: instructionsLabel.leadingAnchor),
            instructionDescription.trailingAnchor.constraint(equalTo: instructionsLabel.trailingAnchor)
        ])
    }
    
    private func setupIngredientsTableView() {
        ingredientsTableView.dataSource = self
        ingredientsTableView.register(IngredientTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifiers.ingredientTableViewCell)
        contentView.addSubview(ingredientsTableView)
        ingredientsTableViewHeightConstraint = ingredientsTableView.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([
            ingredientsTableView.topAnchor.constraint(equalTo: instructionDescription.bottomAnchor, constant: 20),
            ingredientsTableView.leadingAnchor.constraint(equalTo: instructionDescription.leadingAnchor),
            ingredientsTableView.trailingAnchor.constraint(equalTo: instructionDescription.trailingAnchor),
            ingredientsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ingredientsTableViewHeightConstraint!
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ingredientsTableView.frame.size.height = ingredientsTableView.contentSize.height
        ingredientsTableViewHeightConstraint?.constant = ingredientsTableView.frame.height
    }
    
    private func loadMealDetails() {
        guard let mealID = mealID else { return }
        IngredientViewModel()
            .getMealDetail(for: mealID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mealDetail in
                self?.title = mealDetail.name
                self?.instructionDescription.text = mealDetail.instructions
                self?.ingredients = mealDetail.ingredients
                self?.ingredientsTableView.reloadData()
                self?.view.setNeedsLayout()
            }
            .store(in: &cancellables)
    }
}

extension IngredientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifiers.ingredientTableViewCell, for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        cell.setUp(with: ingredients[indexPath.row])
        return cell
    }
}
