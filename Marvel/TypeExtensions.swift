//
//  TypeExtensions.swift
//  Marvel
//
//  Created by Ahmed El-Kollaly on 9/2/19.
//  Copyright © 2019 Ahmed El-Kollaly. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit
import SystemConfiguration



/// Wrapper function for "DispatchQueue.global().async" function
func async(_ block: (()->())?){
    
    guard let block = block else { return }
    
    DispatchQueue.global().async(execute: block)
    
}

/// Wrapper function for "DispatchQueue.main.async" function
func async_main(_ block:(()->())?){
    guard let block = block else { return }
    
    DispatchQueue.main.async(execute: block)
}


extension String {
    
    /// MD5 Hashing algorithm for hashing a string instance.
    ///
    /// - Returns: The requested hash output or nil if failure.
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        return String(format: hash as String)
    }
}

/// Add new cells with animation to UICollectionView
extension UICollectionView {
    
    
    func applyChanges(section: Int = 0,deletions:[Int],insertions:[Int],updates:[Int]){
        
        self.performBatchUpdates({
            
            //Insert new Items
            self.insertItems(at: insertions.map{IndexPath(item: $0, section: section)})
            
            //Delete items
            self.deleteItems(at: deletions.map{IndexPath(item: $0, section: section)})
            
            //Reload updates
            self.reloadItems(at: updates.map{IndexPath(item: $0, section: section)})
            
        }){
            success in
            
            print("Apply Changes: \(success)")
        }
        
        
    }
    
    
}



/// Custom UIImageView class for image loading
@IBDesignable
class CachedImageView: UIImageView {
    
    public static let imageCache = NSCache<NSString, DiscardableImageCacheItem>()
    
    
    private var urlStringForChecking: String?
  
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
   
    
    /**
     Easily load an image from a URL string and cache it to reduce network overhead later.
     
     - parameter urlString: The url location of your image, usually on a remote server somewhere.
     - parameter completion: Optionally execute some task after the image download completes
     */
    
    open func loadImage(urlString: String, completion: (() -> ())? = nil) {
        image = nil
        
        self.urlStringForChecking = urlString
        
        let urlKey = urlString as NSString
        
        if let cachedItem = CachedImageView.imageCache.object(forKey: urlKey) {
            image = cachedItem.image
            completion?()
            return
        }
        
        guard let url = URL(string: urlString) else {
           
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            if error != nil {
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    let cacheItem = DiscardableImageCacheItem(image: image)
                    CachedImageView.imageCache.setObject(cacheItem, forKey: urlKey)
                    
                    if urlString == self?.urlStringForChecking {
                        self?.image = image
                        completion?()
                    }
                }
            }
            
        }).resume()
    }
}


class DiscardableImageCacheItem: NSObject, NSDiscardableContent {
    
    private(set) public var image: UIImage?
    var accessCount: UInt = 0
    
    public init(image: UIImage) {
        self.image = image
    }
    
    public func beginContentAccess() -> Bool {
        if image == nil {
            return false
        }
        
        accessCount += 1
        return true
    }
    
    public func endContentAccess() {
        if accessCount > 0 {
            accessCount -= 1
        }
    }
    
    public func discardContentIfPossible() {
        if accessCount == 0 {
            image = nil
        }
    }
    
    public func isContentDiscarded() -> Bool {
        return image == nil
    }
    
}



/// A computed variable to check if device is connected to internet or not
var isConnectedToNetwork : Bool {
    
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
    
    return (isReachable && !needsConnection)
    
}




/// Insert blur view in the specified view with style
///
/// - Parameters:
///   - view: the view to insert blur in
///   - style: blur style

func insertBlurView (view: UIView, style: UIBlurEffect.Style) {
    view.backgroundColor = UIColor.clear
    
    let blurEffect = UIBlurEffect(style: style)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = view.bounds
    view.insertSubview(blurEffectView, at: 0)
}


extension String {
    
    
    /// function to capitalize first letter of string only
    ///
    /// - Returns: string with capitalized first letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}



/// Custom Search bar to remove cancel button
class CustomSearchBar: UISearchBar {
    
    override func setShowsCancelButton(_ showsCancelButton: Bool, animated: Bool) {
        super.setShowsCancelButton(false, animated: false)
    }
    
}

class CustomSearchController: UISearchController, UISearchBarDelegate {
    
    lazy var _searchBar: CustomSearchBar = {
        [unowned self] in
        let customSearchBar = CustomSearchBar(frame: CGRect.zero)
        customSearchBar.delegate = self
        return customSearchBar
        }()
    
    override var searchBar: UISearchBar {
        get {
            return _searchBar
        }
    }
    
}
