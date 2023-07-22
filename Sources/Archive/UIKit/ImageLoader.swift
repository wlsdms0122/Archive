//
//  ImageLoader.swift
//
//
//  Created by JSilver on 2023/07/19.
//

import UIKit

public class ImageLoader {
    // MARK: - Property
    public static var shared: ImageLoader = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Initializer
    private init() { }
    
    // MARK: - Public
    public func load(url: URL?) async -> UIImage? {
        guard let url = url else { return nil }
        
        let key = NSString(string: url.absoluteString)
        
        if let image = cache.object(forKey: key) {
            return image
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }
            cache.setObject(image, forKey: key)
            
            return image
        } catch {
            return nil
        }
    }
    
    // MARK: - Private
}
