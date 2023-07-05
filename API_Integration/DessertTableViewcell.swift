//
//  DessertTableViewcell.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/27/23.
//

import UIKit

class DessertTableViewCell: UITableViewCell {
    
    private lazy var mealImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageView.layer.shadowRadius = 4
        return imageView
    }()
    
    private lazy var mealName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.font.helveticaBold, size: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        heightAnchor.constraint(equalToConstant: 150).isActive = true
        backgroundColor = .clear
        configureImageView()
        configureMealName()
    }
    
    func setUp(with meal: Meal) {
        mealImage.image = meal.image
        mealName.text = meal.name
    }
    
    private func configureImageView() {
        addSubview(mealImage)
        NSLayoutConstraint.activate([
            mealImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            mealImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            mealImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mealImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    private func configureMealName() {
        addSubview(mealName)
        NSLayoutConstraint.activate([
            mealName.leadingAnchor.constraint(equalTo: mealImage.leadingAnchor, constant: 15),
            mealName.bottomAnchor.constraint(equalTo: mealImage.bottomAnchor, constant: -10),
            mealName.trailingAnchor.constraint(equalTo: mealImage.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

