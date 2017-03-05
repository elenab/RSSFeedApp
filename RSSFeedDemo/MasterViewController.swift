//
//  MasterViewController.swift
//  RSSFeedDemo
//
//  Created by Elena Busila on 2017-03-04.
//  Copyright © 2017 Elena Busila. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import FeedKit

class MasterViewController: UITableViewController {

    var detailViewController: FeedDetailViewController? = nil
    var objects = [Any]()
    var RSSURL: String = "http://www.cbc.ca/cmlink/rss-topstories"
    var RSSTitle: String = "CBC News"
    var feeds: RSSFeed?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            
        let changeFeedBtn = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(changeFeedURL(_:)))
        self.navigationItem.rightBarButtonItem = changeFeedBtn
        
        self.title = RSSTitle
        self.loadNews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func changeFeedURL(_ sender: Any) {
        let alertController = UIAlertController(title: "Change Feed URL", message: "Enter the new url below: ", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            if let title = alertController.textFields![0].text, !title.isEmpty,
                let URL = alertController.textFields![1].text, !URL.isEmpty {
                
                if(validateURL(urlString: URL)) {
                    self.RSSURL = URL
                    self.RSSTitle = title
                    self.title = title
                    
                    self.loadNews()
                } else {
                    self.makeToast(message: "Invalid URL!")
                }
            } else {
                self.makeToast(message: "The fields cannot be empty!")
            }

            print("RSS: \(self.RSSTitle), \(self.RSSURL)")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter the feed title: (CBC)"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "http://www.cbc.ca/cmlink/rss-topstories"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow,
                let feedItem = self.feeds?.items?[indexPath.row] {
                
                let controller = (segue.destination as! UINavigationController).topViewController as! FeedDetailViewController
                controller.link = feedItem.link
                controller.title = feedItem.title
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.feeds?.items?.count ?? 0
        default: fatalError()
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
         if let item = self.feeds?.items?[indexPath.row] {
            cell.articleTitle.text = item.title ?? "<No title>"
            cell.articleDate.text = "Publication Date: " + dateAsString(date: item.pubDate)
            cell.articleAuthor.text = "Author: " + (item.author ?? "No author")
            
            if let description = item.description {
                var imageFromCDATA = getImageURLFromCDATA(description: description)
                var imageURL: URL
                
                if ( imageFromCDATA == "" ) { //no image in CDATA try enclosure attributes
                    imageFromCDATA = (item.enclosure?.attributes?.url)!
                }
                    
                imageURL = URL(string: imageFromCDATA)!
                cell.articleImageView.kf.setImage(with: imageURL, placeholder: UIImage(named: "noimage"))
                
        }
        }
        return cell
    }
    
    func loadNews() {
        print(self.RSSURL)
        let URLEncoded = self.RSSURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        if let feedURL = URL(string: URLEncoded!){
                FeedParser(URL: feedURL)?.parse({ (result) in
                guard let _ = result.rssFeed, result.isSuccess else {
                    self.makeToast(message: result.error!.description)
                    return
                }
                self.feeds = result.rssFeed
                self.tableView.reloadData()
            })
        }
    }
    
    func makeToast (message: String?) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/4 - 50, y: self.view.frame.size.height/2 - 100, width: self.view.frame.size.width/2 + 100, height: 100))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.text = message
        
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: nil)
    }
}

