//
//  Model.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation
import UIKit


enum MealCategory: String {
    case dessert = "Dessert"
}

struct Meal {
    let name: String
    let image: UIImage
    let id: Int
}

struct Ingredient {
    let name: String
    let quantity: String
}

struct MealDetail {
    let name: String
    let instructions: String
    let ingredients: [Ingredient]
}

