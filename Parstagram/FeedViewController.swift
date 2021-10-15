//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Chandana Pemmasani on 10/6/21.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var feedTable: UITableView!
    
    var posts = [PFObject]()
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRefreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        feedTable.insertSubview(myRefreshControl, at: 0)
        
        feedTable.delegate = self
        feedTable.dataSource = self
        
//        self.feedTable.estimatedRowHeight = 60.0;
        self.feedTable.rowHeight = UITableView.automaticDimension

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 443
        }
        
            return 55
        
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginController = main.instantiateViewController(withIdentifier: "loginScreen")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginController
        
    }
    
    
    @objc func onRefresh() {
        run(after: 2) {
               self.myRefreshControl.endRefreshing()
            }
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.feedTable.reloadData()
                
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         
        let post = posts[section]
        let comments = post["comments"] as? [PFObject] ?? []
            
        
        return comments.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         
        let post = posts[indexPath.section]
        let comments = (post["comments"]) as? ([PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            
            let user = post["author"] as! PFUser
            
            cell.usernameLbl.text = user.username
            cell.captionLbl.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString =  imageFile.url!
            let url = URL(string: urlString)!
            
            cell.feedPhotoview.af_setImage(withURL: url)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as!  CommentsTableViewCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentContent.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.commentName.text = user.username
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        post.add(comment, forKey: "comments")
        
        post.saveInBackground {(success, error) in
            if success {
                print("comment saved")
            } else {
                print("error saving comment")
            }
            
        }
        
    }
}
