//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Natalie Meneses on 10/21/20.
//  Copyright © 2020 NatalieM. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar
class FeedViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
  @IBOutlet weak var tableView: UITableView!
   let commentBar = MessageInputBar()
   var showsCommentBar = false
    var posts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate=self
        tableView.dataSource=self
        
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    override var inputAccessoryView: UIView?{
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool{
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author", "comments", "comments.author"]) //for each comment find the respective author
        query.limit = 20
        
        query.findObjectsInBackground { (posts, Error) in
            if(posts != nil)
            {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
            
        }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject] ?? [])
        //?? is a nil coalescing operator: whatever is on the left, if its nil, set it eqal to whatever is in brackets
        return comments.count+2
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let comments = (post["comments"] as? [PFObject] ?? [])
         
        if indexPath.row == 0{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
       
        let user=post["author"] as! PFUser
        cell.userNameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        
        cell.photoView.af_setImage(withURL: url)
            
        return cell
        }
        else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")
            as! CommentCell
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
         return cell
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")
            return cell
            }
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post=posts[indexPath.row]
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["post"] = posts
        comment["author"] = PFUser.current()!
        post.add(comment, forKey: "comments")
        post.saveInBackground { (success, error) in
            if success{
                print("Comment saved")
            }
            else
            {
                print("Error saving comment")
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let delegate = windowScene.delegate as? SceneDelegate
           else {
                 return
            }
        delegate.window?.rootViewController = loginViewController
    
    }
    
}
