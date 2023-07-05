//
//  UIImageView+Extension.swift
//  API_Integration
//
//  Created by Kalyan Chakravarthy Narne on 6/26/23.
//

import Foundation
import SystemConfiguration
import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    static func downloadImage(from urlString: String, placeholder: UIImage? = nil, completion: @escaping ((UIImage) -> Void)) {
        let key = NSString(string: urlString)
        
        // Check if the image already exists in the cache
        if let cachedImage = imageCache.object(forKey: key) {
            completion(cachedImage)
            return
        }
        
        // Check network connectivity
        if !isConnectedToNetwork() {
            if let placeholderImage = placeholder {
                completion(placeholderImage)
            }
            return
        }
        
        // Make a URL request to download the image
        guard let url = URL(string: urlString) else {
            if let placeholderImage = placeholder {
                completion(placeholderImage)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let downloadedImage = UIImage(data: data) {
                imageCache.setObject(downloadedImage, forKey: key)
                completion(downloadedImage)
            } else if let placeholderImage = placeholder {
                completion(placeholderImage)
            }
        }.resume()
    }
    
    private static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return isReachable && !needsConnection
    }
}
