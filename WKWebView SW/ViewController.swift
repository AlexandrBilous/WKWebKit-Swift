//
//  ViewController.swift
//  WKWebView SW
//
//  Created by Marentilo on 02.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pdfs : [String]!
    var sites : [String]!
    
    private let cellIdentidier = "UITableViewCell"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        createData()
        navigationItem.title = "Safari"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentidier)
    }
    
    
    func createData () {
        pdfs = ["AppleDesign", "ObjectiveC", "SwiftCheatsheet", "UIPresentationController", "GCD", "GCD_Swift4_1", "GCD_Swift4_2", "OperationQueue"]
        sites = ["Flaticon", "Facebook","Apple","Youtube", "Google", "Instagram", "Forbes", "Aliexpress"]
    }
    
    func presentDirectory (atPath path: String, section: Int) {
        let viewController = WebViewController(url: path, isSite: section == 1)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentidier)
        cell?.textLabel?.text = indexPath.section == 0 ? pdfs[indexPath.row] : sites[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell?.imageView?.image = indexPath.section == 0 ? UIImage(named: "pdf") : UIImage(named: "www")
        
        return cell!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? pdfs.count : sites.count
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentDirectory(atPath: tableView.cellForRow(at: indexPath)?.textLabel?.text ?? "nil", section: indexPath.section)
    }

}

