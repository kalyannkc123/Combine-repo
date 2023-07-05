//
//  IngredientViewModel.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Combine

struct IngredientViewModel {
    private let mealsInfo: MealsInfo
    
    init(using mealsInfo: MealsInfo = NetworkManager()) {
        self.mealsInfo = mealsInfo
    }
    
    func getMealDetail(for id: Int) -> AnyPublisher<MealDetail, Never> {
        mealsInfo.getMealDetails(for: id)
            .map { mealInfo in
                let filteredIngredients = mealInfo.ingredients.filter { !$0.name.isEmpty && !$0.quantity.isEmpty }
                return MealDetail(
                    name: mealInfo.name,
                    instructions: mealInfo.instructions,
                    ingredients: filteredIngredients
                )
            }
            .eraseToAnyPublisher()
    }
}
