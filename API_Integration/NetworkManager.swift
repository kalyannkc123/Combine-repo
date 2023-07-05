//
//  NetworkManager.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation
import UIKit
import Combine

struct MealResponse<T:Codable>: Codable {
    var meals: T
}

enum NetworkError: Error {
    case invalidResponse
}


struct NetworkManager: MealsInfo {
    
    private let networkModel: NetworkModel
    
    init(networkModel: NetworkModel = NetworkModel()) {
        self.networkModel = networkModel
    }
    
    func getMeal(for category: MealCategory) -> AnyPublisher<[Meal], Never> {
        let url = Endpoints.fetchMealsByCategory(mealCategory: category).url

        return networkModel.makeRequest(at: url)
            .flatMap { (response: MealResponse<[MealResponseModel]>) -> AnyPublisher<[Meal], Never> in
                let mealssPublisher = response.meals.publisher
                    .flatMap { mealResponseModel -> AnyPublisher<Meal?, Never> in
                        let id = Int(mealResponseModel.id)
                        return Future<Meal?, Never> { promise in
                            UIImageView.downloadImage(from: mealResponseModel.imageURL) { image in
                                let item = Meal(name: mealResponseModel.name, image: image, id: id ?? 0)
                                promise(.success(item))
                            }
                        }
                        .eraseToAnyPublisher()
                    }
                    .collect()
                    .map { $0.compactMap { $0 } }
                    .eraseToAnyPublisher()

                return mealssPublisher
            }
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }


    
    
    
    func getMealDetails(for id: Int) -> AnyPublisher<MealDetail, Never> {
        let url = Endpoints.fetchMealDetails(id: id).url
        return networkModel.makeRequest(at: url)
            .map { (response: MealResponse<[MealDetailsResponseModel]>) -> MealDetail in
                guard let itemDetails = response.meals.first else {
                    return MealDetail(name: " ", instructions: " ", ingredients: [])
                }
                let ingredients = [
                    Ingredient(name: itemDetails.ingredient1 ?? "", quantity: itemDetails.measurement1 ?? ""),
                    Ingredient(name: itemDetails.ingredient2 ?? "", quantity: itemDetails.measurement2 ?? ""),
                    Ingredient(name: itemDetails.ingredient3 ?? "", quantity: itemDetails.measurement3 ?? ""),
                    Ingredient(name: itemDetails.ingredient4 ?? "", quantity: itemDetails.measurement4 ?? ""),
                    Ingredient(name: itemDetails.ingredient5 ?? "", quantity: itemDetails.measurement5 ?? ""),
                    Ingredient(name: itemDetails.ingredient6 ?? "", quantity: itemDetails.measurement6 ?? ""),
                    Ingredient(name: itemDetails.ingredient7 ?? "", quantity: itemDetails.measurement7 ?? ""),
                    Ingredient(name: itemDetails.ingredient8 ?? "", quantity: itemDetails.measurement8 ?? ""),
                    Ingredient(name: itemDetails.ingredient9 ?? "", quantity: itemDetails.measurement9 ?? ""),
                    Ingredient(name: itemDetails.ingredient10 ?? "", quantity: itemDetails.measurement10 ?? ""),
                    Ingredient(name: itemDetails.ingredient11 ?? "", quantity: itemDetails.measurement11 ?? ""),
                    Ingredient(name: itemDetails.ingredient12 ?? "", quantity: itemDetails.measurement12 ?? ""),
                    Ingredient(name: itemDetails.ingredient13 ?? "", quantity: itemDetails.measurement13 ?? ""),
                    Ingredient(name: itemDetails.ingredient14 ?? "", quantity: itemDetails.measurement14 ?? ""),
                    Ingredient(name: itemDetails.ingredient15 ?? "", quantity: itemDetails.measurement15 ?? ""),
                    Ingredient(name: itemDetails.ingredient16 ?? "", quantity: itemDetails.measurement16 ?? ""),
                    Ingredient(name: itemDetails.ingredient17 ?? "", quantity: itemDetails.measurement17 ?? ""),
                    Ingredient(name: itemDetails.ingredient18 ?? "", quantity: itemDetails.measurement18 ?? ""),
                    Ingredient(name: itemDetails.ingredient19 ?? "", quantity: itemDetails.measurement19 ?? ""),
                    Ingredient(name: itemDetails.ingredient20 ?? "", quantity: itemDetails.measurement20 ?? "")
                ]
                
                return MealDetail(name: itemDetails.name, instructions: itemDetails.instructions, ingredients: ingredients)
            }
            .replaceError(with: MealDetail(name: " ", instructions: " ", ingredients: []))
            .eraseToAnyPublisher()
    }
}
