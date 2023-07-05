//
//  URLEndPoint.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation
protocol URLEndPoint {
    var scheme: String  { get }
    var host: String  { get }
    var path: String  { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
}
