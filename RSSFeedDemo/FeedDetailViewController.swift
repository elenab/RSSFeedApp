//
//  FeedDetailViewController.swift
//  RSSFeedDemo
//
//  Created by Elena Busila on 2017-03-04.
//  Copyright © 2017 Elena Busila. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {

    @IBOutlet weak var detailWebView: UIWebView!

    func configureView() {
        // Update the user interface for the detail item.
        if let link = self.link?.description {
            print(link)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backAction))
        
        if let feedLink = URL (string: (self.link?.description)!) {
            let requestObj = URLRequest(url: feedLink)
            self.detailWebView.loadRequest(requestObj)
        }
        
    }
    
    func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var link: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

