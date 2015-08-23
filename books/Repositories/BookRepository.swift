 //
//  BookRepository.swift
//  books
//
//  Created by Dave Alton on 2015-08-20.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation

class BookRepository {
    
    class func getBooksBySearchTerm(search: String, startIndex: Int, success:(Array<Book>)->()){
        var urlSearch = search.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        var url = "https://www.googleapis.com/books/v1/volumes?q=\(urlSearch)&key=AIzaSyB0IxSLS_nnEWA_wWoqbohNv0cxO1hcoic&maxResults=40&startIndex=\(startIndex)&fields=items(accessInfo%2Fembeddable%2CvolumeInfo(authors%2CaverageRating%2Cdescription%2CimageLinks%2CindustryIdentifiers%2Cpublisher%2Ctitle))"
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
            var json = JSON(url: url)
            dispatch_async( dispatch_get_main_queue(), {
                var books = Array<Book>()
                if json["error"]["message"].asString == nil {
                    if json["items"].asArray != nil {
                        for var i = 0; i < json["items"].asArray!.count; i++ {
                            var title = json["items"][i]["volumeInfo"]["title"].asString!
                            var authors = ""
                            if json["items"][i]["volumeInfo"]["authors"].asArray != nil {
                                for var j = 0; j < json["items"][i]["volumeInfo"]["authors"].asArray!.count; j++ {
                                    var author = json["items"][i]["volumeInfo"]["authors"][j].asString!
                                    if j == json["items"][i]["volumeInfo"]["authors"].asArray!.count - 1 && j != 0 {
                                        authors += ", and "
                                    } else if j != 0 {
                                        authors += ", "
                                    }
                                    authors += author
                                }
                            }
                            var smallThumb = json["items"][i]["volumeInfo"]["imageLinks"]["smallThumbnail"].asString
                            var largeThumb = json["items"][i]["volumeInfo"]["imageLinks"]["thumbnail"].asString
                            var isbn = ""
                            if json["items"][i]["volumeInfo"]["industryIdentifiers"].asArray != nil {
                                for var j = 0; j < json["items"][i]["volumeInfo"]["industryIdentifiers"].asArray!.count; j++ {
                                    if json["items"][i]["volumeInfo"]["industryIdentifiers"][j]["type"].asString!  == "ISBN_10" {
                                        isbn = json["items"][i]["volumeInfo"]["industryIdentifiers"][j]["identifier"].asString!
                                    }
                                }
                            }
                            var embeddable = json["items"][i]["accessInfo"]["embeddable"].asBool!
                            var publisher = json["items"][i]["volumeInfo"]["publisher"].asString
                            var summary = json["items"][i]["volumeInfo"]["description"].asString
                            var rating = json["items"][i]["volumeInfo"]["averageRating"].asDouble
                            var book = Book(title: title, authors: authors, publisher: publisher, summary: summary, rating: rating, isbn: isbn, smallThumb: smallThumb, largeThumb: largeThumb, embeddable: embeddable)
                            books.append(book)
                        }
                    }
                } else {
                    println(json["error"]["message"].asString!)
                }
                success(books)
            });
        });
    }
}