//
//  Utilities.swift
//  RSSFeedDemo
//
//  Created by Elena Busila on 2017-03-04.
//  Copyright © 2017 Elena Busila. All rights reserved.
//
import UIKit
import Foundation

func validateURL (urlString: String?) -> Bool {
    if let urlString = urlString {
        if let url = NSURL(string: urlString) {
            // check if application can open the URL
            return UIApplication.shared.canOpenURL(url as URL)
        }
    }
    return false
}

func getImageURLFromCDATA (description: String?) -> String {
    var returnString = ""
    do {
        let regex = try NSRegularExpression(pattern: "(src\\s*=\\s*?(.+?)[|\\s])", options: [])
        if let CDATA = description {
            let range = NSMakeRange(0, CDATA.characters.count)
            regex.enumerateMatches(in: CDATA, options: [], range: range) { (result, _, _) -> Void in
                let nsrange = result!.rangeAt(2)
                let start = CDATA.index(CDATA.startIndex, offsetBy: nsrange.location + 1)
                let end = CDATA.index(start, offsetBy: nsrange.length - 2)
                print(CDATA[start..<end])
                returnString = CDATA[start..<end]
            }
        }
    } catch {
        print("error")
    }
    return returnString
}

func dateAsString(date: Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let str = dateFormatter.string(from: date!)
    return str
}
