//
//  Protocol.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation
import Combine
protocol MealsInfo {
    func getMeal(for category: MealCategory) -> AnyPublisher<[Meal], Never>
    func getMealDetails(for id: Int) -> AnyPublisher<MealDetail, Never>
}

