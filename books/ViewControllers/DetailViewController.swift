//
//  DetailViewController.swift
//  books
//
//  Created by Dave Alton on 2015-08-20.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation

class DetailViewController: UIViewController {
    
    @IBOutlet var coverButton: UIButton!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var noPreviewLabel: UILabel!
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var starsLabel: UILabel!
    @IBOutlet var summaryLabel: UILabel!
    @IBOutlet var publisherLabel: UILabel!
    
    @IBOutlet var summaryHeight: NSLayoutConstraint!
    
    var book: Book!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if book.largeThumb != nil {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                var coverImage = self.book.getThumb(self.book.largeThumb)
                dispatch_async( dispatch_get_main_queue(), {
                    self.coverButton.setBackgroundImage(coverImage, forState: .Normal)
                    self.coverButton.setBackgroundImage(coverImage, forState: .Selected)
                });
            });
        } else if book.smallThumb != nil {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                var coverImage = self.book.getThumb(self.book.smallThumb)
                dispatch_async( dispatch_get_main_queue(), {
                    self.coverButton.setBackgroundImage(coverImage, forState: .Normal)
                    self.coverButton.setBackgroundImage(coverImage, forState: .Selected)
                });
            });
        } else {
            coverButton.titleLabel!.text = "Tap here to read a preview"
        }
        
        navigationBar.topItem!.title = book.title
        if book.authors != nil {
            authorLabel.text = book.authors!
        }
        
        if book.embeddable {
            noPreviewLabel.alpha = 0
        }
        
        summaryLabel.text = book.summary
        publisherLabel.text = book.publisher
        
        summaryLabel.numberOfLines = 0
        summaryLabel.sizeToFit()
        summaryHeight.constant = summaryLabel.frame.height
        
        var starsString = ""
        if book.rating != nil {
            for var i = book.rating!; i > 0; i = i - 1 {
                if i == 0.5 {
                    starsString += "½"
                    i = 0
                } else {
                    starsString += "★"
                }
            }
        }
        starsLabel.text = starsString
    }
    
    @IBAction func unwindToDetail(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier != nil {
            if segue.identifier! == "preview" {
                if book.embeddable {
                    var previewViewController: PreviewViewController = segue.destinationViewController as! PreviewViewController
                    previewViewController.book = book
                }
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier != nil {
            if identifier! == "preview" {
                return book.embeddable
            }
        }
        return true
    }
    
}