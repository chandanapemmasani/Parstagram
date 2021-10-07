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
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.feedTable.reloadData()
                
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = feedTable.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        
        let user = post["author"] as! PFUser
        
        cell.usernameLbl.text = user.username
        cell.captionLbl.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString =  imageFile.url!
        let url = URL(string: urlString)!
        
        cell.feedPhotoview.af_setImage(withURL: url)
        
        return cell
    }
}
