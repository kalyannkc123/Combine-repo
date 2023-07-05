//
//  Endpoints.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation

enum Endpoints: URLEndPoint {
    
    case fetchMealsByCategory(mealCategory: MealCategory)
    case fetchMealDetails(id: Int)
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "www.themealdb.com"
    }
    
    var path: String {
        switch self {
        case .fetchMealsByCategory:
            return "/api/json/v1/1/filter.php"
        case .fetchMealDetails:
            return "/api/json/v1/1/lookup.php"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case .fetchMealsByCategory(let mealCategory):
            return [URLQueryItem(name: QueryParameters.category, value: mealCategory.rawValue)]
        case .fetchMealDetails(id: let id):
            return [URLQueryItem(name: QueryParameters.id, value: String(id))]
        }
    }
    
    var url: URL {
        var urlComponent = URLComponents()
        urlComponent.host = host
        urlComponent.scheme = scheme
        urlComponent.path = path
        urlComponent.queryItems = queryItems
        return urlComponent.url!
    }
}

private enum QueryParameters {
    //It is a constant value associated with the enumeration case.
    //Enumerations, on the other hand, have associated values or associated properties, which are distinct from stored properties.
    static let category = "c"
    static let id = "i"
}


