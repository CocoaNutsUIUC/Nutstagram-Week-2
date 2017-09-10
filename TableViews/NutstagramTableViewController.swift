//
//  NutstagramTableViewController.swift
//  TableViews
//
//  Created by Jared Franzone on 7/19/17.
//  Copyright © 2017 Jared Franzone. All rights reserved.
//

import UIKit

final class NutstagramTableViewController: UIViewController {

    
    
    // MARL: IB Outlets
    
    @IBOutlet weak var tableview: UITableView!
    
    
    
    // MARK: Properties
    
    var posts = [Post]()
    
    
    // MARK: ViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // load the fake data
        loadFakeData()
    }

    // MARK: Private Helper methods
    
    private func loadFakeData() {
        
        posts.removeAll()
        
        posts.append(
            Post(
                author:  User(name: "Jared Franzone", emojiProfilePic: "🕵🏼"),
                image:  #imageLiteral(resourceName: "lentils"),
                numLikes: 5,
                comments: ["Lentils :)", "Yum!", "Can you make tose in the microwave?", "I'd rather have pizza"]
            )
        )
        posts.append(
            Post(
                author: User(name: "John Smith", emojiProfilePic: "👨🏽‍✈️"),
                image: #imageLiteral(resourceName: "sailboats"),
                numLikes: 9,
                comments: ["Look at all the sailboats!","I see a whale", "⛵️"]
            )
        )
        posts.append(
            Post(author: User(name: "Jane Doe", emojiProfilePic: "👩🏻‍⚖️"),
                 image: #imageLiteral(resourceName: "cave"),
                 numLikes: 22,
                 comments: ["having soo much fun in TX!", "Wow! cool cave", "Where is that place?"]
            )
        )
        
    }
    
}


// MARK: - UITableViewDelegate extension

extension NutstagramTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}



// MARK: - UITableViewDataSource extension

extension NutstagramTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? NutstagramTableViewCell else {
            return NutstagramTableViewCell()
        }
        
        configure(cell: cell, at: indexPath, with: posts[indexPath.row])
            
        return cell
    }
    
    func configure(cell: NutstagramTableViewCell, at indexPath: IndexPath, with post: Post) {
        
        cell.userNameLabel.text = post.author.nameWithPic
        cell.postImageView.image = post.image
        
        (post.isLiked) ? cell.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal) : cell.likeButton.setImage(#imageLiteral(resourceName: "default"), for: .normal)
        
        cell.likedByLabel.text = "\(post.numLikes) \(post.numLikes == 1 ? "like" : "likes")"
        cell.userCommentLabel.text = post.comments.first
        cell.viewAllCommentsButton.setTitle("View all \(post.comments.count) comments", for: .normal)
    }

}
