//
//  URLImageView.swift
//
//
//  Created by JSilver on 2023/07/19.
//

import UIKit

public class URLImageView: UIImageView {
    // MARK: - Property
    private var task: Task<Void, Error>? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    // MARK: - Initializer
    
    // MARK: - Lifecycle
    
    // MARK: - Public
    public func setImage(url: URL?, placeholder: UIImage? = nil, completion: ((UIImage?) -> Void)? = nil) {
        image = placeholder
        
        self.task = Task { [weak self] in
            let image = await ImageLoader.shared.load(url: url)
            
            if let completion {
                completion(image)
            } else {
                self?.image = image
            }
        }
    }
    
    // MARK: - Private
}
