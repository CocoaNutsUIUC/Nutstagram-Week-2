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
        loadDataFromServer()
    }

    // MARK: Private Helper methods
    
    private func loadDataFromServer() {
        if let url = URL(string: "http://nutstagramapi-env-2.j3tcbpybxd.us-east-1.elasticbeanstalk.com/posts") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let defaultSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
            
            let dataTask = defaultSession.dataTask(with: request)
            dataTask.resume()
        }
    }
    
//    private func loadFakeData() {
//        
//        posts.removeAll()
//        
//        posts.append(
//            Post(
//                author:  User(name: "Jared Franzone", emojiProfilePic: "🕵🏼"),
//                image:  #imageLiteral(resourceName: "lentils"),
//                numLikes: 5,
//                comments: ["Lentils :)", "Yum!", "Can you make tose in the microwave?", "I'd rather have pizza"]
//            )
//        )
//        posts.append(
//            Post(
//                author: User(name: "John Smith", emojiProfilePic: "👨🏽‍✈️"),
//                image: #imageLiteral(resourceName: "sailboats"),
//                numLikes: 9,
//                comments: ["Look at all the sailboats!","I see a whale", "⛵️"]
//            )
//        )
//        posts.append(
//            Post(author: User(name: "Jane Doe", emojiProfilePic: "👩🏻‍⚖️"),
//                 image: #imageLiteral(resourceName: "cave"),
//                 numLikes: 22,
//                 comments: ["having soo much fun in TX!", "Wow! cool cave", "Where is that place?"]
//            )
//        )
//        
//    }
    
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
//        cell.postImageView.image = post.image
        if let image = post.image {
            cell.postImageView.image = resize(image: image)
        } else {
            loadImage(from: post.imageURL, for: cell, at: indexPath)
        }
        
        (post.isLiked) ? cell.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal) :
            cell.likeButton.setImage(#imageLiteral(resourceName: "default"), for: .normal)
        
        cell.likedByLabel.text = "\(post.numLikes) \(post.numLikes == 1 ? "like" : "likes")"
        cell.userCommentLabel.text = post.comments.first
        cell.viewAllCommentsButton.setTitle("View all \(post.comments.count) comments", for: .normal)
    }
    
    private func loadImage(from url: URL, for cell: NutstagramTableViewCell, at indexPath: IndexPath) {
        DispatchQueue(label: "LoadImage").async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            guard let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                self.posts[indexPath.row].image = image
                self.tableview.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }

}

extension NutstagramTableViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        let postsJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        
        guard let postsInfo = postsJSON as? [[String: Any]] else { return }
        
        var posts = [Post]()
        
        for postInfo in postsInfo {
            
            guard let imageURLString = postInfo["image_url"] as? String else { return }
            guard let numLikes = postInfo["num_likes"] as? Int else { return }
            
            guard let userInfo = postInfo["user"] as? [String: Any] else { return }
            guard let commentsInfo = postInfo["comments"] as? [[String: Any]] else { return }
            
            guard let userName = userInfo["name"] as? String else { return }
            guard let userEmojiProfilePic = userInfo["emoji_profile_pic"] as? String else { return }
            
            var comments = [String]()
            
            for commentInfo in commentsInfo {
                guard let text = commentInfo["text"] as? String else { return }
                comments.append(text)
            }
            
            guard let imageURL = URL(string: imageURLString) else { return }
            
            let user = User(name: userName, emojiProfilePic: userEmojiProfilePic)
            let post = Post(author: user, imageURL: imageURL, numLikes: numLikes, comments: comments)
            
            posts.append(post)
            
        }
        
        self.posts = posts
        
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
        
    }
}
