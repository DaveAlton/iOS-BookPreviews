//
//  ViewController.swift
//  books
//
//  Created by Dave Alton on 2015-08-20.
//  Copyright (c) 2015 Alton Enterprises. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var placeholderLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    
    lazy var books = Array<Book>()
    var selectedBook: Book!
    
    
    override func viewWillAppear(animated: Bool) {
        if books.count == 0 {
            placeholderLabel.alpha = 1
        } else {
            placeholderLabel.alpha = 0
        }
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedBook = books[indexPath.item]
        performSegueWithIdentifier("viewDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var detailViewController: DetailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.book = selectedBook
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item > books.count - 9 {
            BookRepository.getBooksBySearchTerm(searchBar.text, startIndex: books.count, success: {
                (books: Array<Book>)->Void in
                self.books += books
                self.updateCollectionView()
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! UICollectionViewCell
        var frame = cell.frame
        if UIDevice.currentDevice().orientation == .Portrait || UIDevice.currentDevice().orientation == .PortraitUpsideDown {
            frame.size.height = self.view.frame.size.height / 3
            frame.size.width = self.view.frame.size.width / 3 - 1
        } else {
            frame.size.height = self.view.frame.size.width / 3
            frame.size.width = self.view.frame.size.height / 3 - 1
        }
        cell.frame = frame
        var imageView = UIImageView(frame: CGRectMake(0,0,cell.frame.size.width,cell.frame.size.height))
        if books[indexPath.item].smallThumb != nil {
            imageView.sd_setImageWithURL(NSURL(string: books[indexPath.item].largeThumb!), placeholderImage: nil)
        }
        cell.addSubview(imageView)
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            BookRepository.getBooksBySearchTerm(searchText, startIndex: 0, success: {
                (books: Array<Book>)->Void in
                self.books = books
                if books.count > 0 {
                    self.placeholderLabel.alpha = 0
                } else {
                    self.placeholderLabel.alpha = 1
                    self.placeholderLabel.text = "Sorry, the search did not return any results"
                }
                self.updateCollectionView()
            })
        } else {
            books = Array<Book>()
            updateCollectionView()
            self.placeholderLabel.alpha = 1
            self.placeholderLabel.text = "Sorry, the search did not return any results"
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func updateCollectionView(){
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width / 3 - 3, height: self.view.frame.size.width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {
        
    }
}

