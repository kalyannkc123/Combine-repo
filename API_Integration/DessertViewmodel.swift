//
//  DessertViewmodel.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/27/23.
//

import Combine

struct DessertViewModel {
    private let mealsInfo: MealsInfo
    
    init(using mealsInfo: MealsInfo = NetworkManager()) {
        self.mealsInfo = mealsInfo
    }
    
    func getMeals(for category: MealCategory) -> AnyPublisher<[Meal], Never> {
        mealsInfo.getMeal(for: category)
            .map { meals in
                meals.filter { !$0.name.isEmpty }
                     .sorted { $0.name.lowercased() < $1.name.lowercased() }
            }
            .eraseToAnyPublisher()
    }
}

