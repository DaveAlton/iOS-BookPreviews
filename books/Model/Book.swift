//
//  Book.swift
//  books
//
//  Created by Dave Alton on 2015-08-20.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation
import UIKit

class Book {
    
    var title: String
    var authors: String?
    var smallThumb: String?
    var largeThumb: String?
    var isbn: String
    var embeddable: Bool
    var summary: String?
    var rating: Double?
    var publisher: String?
    
    init(title: String, authors: String?, publisher: String?, summary: String?, rating: Double?, isbn: String, smallThumb: String?, largeThumb: String?, embeddable: Bool){
        self.title = title
        self.authors = authors
        self.smallThumb = smallThumb
        self.largeThumb = largeThumb
        self.isbn = isbn
        self.embeddable = embeddable
        self.publisher = publisher
        self.rating = rating
        self.summary = summary
    }
    
    func getThumb(size: String?)->UIImage?{
        if size != nil {
            var nsurl = NSURL(string: size!)
            if nsurl != nil {
                var data = NSData(contentsOfURL: nsurl!)
                if data != nil {
                    return UIImage(data: data!)
                }
            }
        }
        return nil
    }
    
}