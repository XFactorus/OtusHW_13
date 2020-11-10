//
//  ViewController.swift
//  OtusHW13
//
//  Created by Vladyslav Pokryshka on 29.10.2020.
//

import UIKit
import Combine

class SharingsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var sharingsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        initSharingsArray()
    }
    
    // MARK: - Actions
    
    // MARK: - TableView
    
    private func configTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = sharingsArray[indexPath.row]
        
        return cell
    }
    
    // MARK: - Main methods
    
    private func initSharingsArray() {
        if let sharedDefaults = UserDefaults(suiteName: "group.otusvp.shared"),
           let sharedArray = sharedDefaults.stringArray(forKey: "sharedStringsArray") ?? [String](),
           sharedArray.count > 0 {
            self.sharingsArray = sharedArray
        }
        self.tableView.reloadData()
    }
}

