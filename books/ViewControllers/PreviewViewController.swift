//
//  PreviewViewController.swift
//  books
//
//  Created by Dave Alton on 2015-08-21.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import Foundation

class PreviewViewController: UIViewController {
    
    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var webView: UIWebView!
    
    var book: Book!
    var previewHtml: String {
        return "<html>" +
                    "<head>" +
                        "<meta http-equiv='content-type' content='text/html; charset=utf-8'/>" +
                        "<title>Google Books Embedded Viewer API Example</title>" +
                        "<script type='text/javascript' src='https://www.google.com/jsapi'></script>" +
                        "<script type='text/javascript'>" +
                            "google.load('books', '0');" +
                            "function initialize() {" +
                                "var viewer = new google.books.DefaultViewer(document.getElementById('viewerCanvas'));" +
                                "viewer.load('ISBN:\(book.isbn)');" +
                            "}" +
                            "google.setOnLoadCallback(initialize);" +
                        "</script>" +
                    "</head>" +
                    "<body>" +
                        "<div id='viewerCanvas' style='width: 100%; height: 100%; margin:0px; padding:0px'></div>" +
                    "</body>" +
                "</html>"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationBar.topItem?.title = book.title
        webView.loadHTMLString(previewHtml, baseURL: nil)
    }
}