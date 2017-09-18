//
//  Post.swift
//  TableViews
//
//  Created by Jared Franzone on 7/20/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import Foundation
import UIKit

struct User {

    
    
    // MARK: Properties

    let name: String
    let emojiProfilePic: String
    var nameWithPic: String {
        // "🕵🏼 Jared Franzone"
        return "\(emojiProfilePic) \(name)"
    }
}

struct Post {

    
    
    // MARK: Properties
    
    public let author: User
    public let imageURL: URL
    public var image: UIImage?
    public var numLikes: Int
    public let comments: [String]

    private(set) public var isLiked: Bool // read-only property

    
    
    // MARK: Initializer
    
//    init(author: User, image: UIImage, numLikes: Int, comments: [String]) {
//        self.author = author
//        self.image = resize(image: image)
//        self.numLikes = numLikes
//        self.comments = comments
//        self.isLiked = false
//    }
    
    init(author: User, imageURL: URL, numLikes: Int, comments: [String]) {
        self.author = author
        self.imageURL = imageURL
        self.numLikes = numLikes
        self.comments = comments
        self.isLiked = false
    }
    
    
    
    // MARK: Methods

    mutating func like() {
        self.isLiked = true
        self.numLikes += 1
    }

    mutating func unLike() {
        self.isLiked = false
        self.numLikes -= 1
    }
    
}

func resize(image: UIImage ) -> UIImage {
    
    // calculate scaling ratio
    let imageWidth = image.size.width
    let screenWidth = (UIDevice.current.orientation == .portrait) ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
    let ratio = Double(screenWidth) / Double(imageWidth)
    
    // resize image
    let size = image.size.applying(CGAffineTransform(scaleX: CGFloat(ratio), y: CGFloat(ratio)))
    UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
    image.draw(in: CGRect(origin: .zero, size: size))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return (scaledImage == nil) ? image : scaledImage!
    
}
