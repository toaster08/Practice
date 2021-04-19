//
//  ListViewController.swift
//  NewsReader
//
//  Created by 山田　天星 on 2021/04/20.
//  Copyright © 2021 toaster. All rights reserved.
//

import UIKit

class ListViewController:UITableViewController,XMLParserDelegate {
    
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentString = ""
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startDownload()
    }
    
    func startDownload(){
        self.items = []
        if let url = URL(
            string:"https://news.yahoo.co.jp/rss/media/bbc/all.xml"){
                if let parser = XMLParser(contentsOf: url) {
                    self.parser = parser
                    self.parser.delegate = self
                    self.parser.parse()
                    print("URLにアクセスしています")
                }
            }
    }
    
    func parser(_ parser:XMLParser,
                didStartElement elementName: String,
                namespaceURI:String?,
                qualifiedName qName:String?,
        attributes attributeDict:[String:String]){
        
        self.currentString = ""
        if elementName == "item"{
            self.item = Item()
            print("Itemのインスタンスを生成しました")
        }
    }

    func parser(_ parser:XMLParser,foundCharacters string:String){
        self.currentString += string
    }
    
    func parser(_ parser:XMLParser,
                didEndElement elementName:String,
                namespaceURI:String?,
                qualifiedName qName:String?){
        
        switch elementName {
        case "title":self.item?.title = currentString
        case "link":self.item?.link = currentString
        case "item":self.items.append(self.item!)
        default:break
        }
    }
    
    func parserDidEndDocument(_ parser:XMLParser){
        self.tableView.reloadData()
    }

}
