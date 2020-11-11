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

    var sharingHistoryVM = SharingHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        initSharingsArray()
    }
    
    // MARK: - Actions
    
    @IBAction func runTestsPressed(_ sender: Any) {
        runTests()
    }
    // MARK: - TableView
    
    private func configTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharingHistoryVM.getElementsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sharedElement = sharingHistoryVM.getElementForIndex(indexPath.row)
        cell.textLabel?.text = sharedElement?.text ?? ""
        cell.detailTextLabel?.text = String(sharedElement?.time ?? 0.0)
        
        return cell
    }
    
    // MARK: - Main methods
    
    private func initSharingsArray() {
        if let sharedDefaults = UserDefaults(suiteName: "group.otusvp.shared"),
           let sharedArray = sharedDefaults.stringArray(forKey: "sharedStringsArray") ?? [String](),
           sharedArray.count > 0 {
            self.sharingHistoryVM.setupWithStringArray(sharedArray)
        }
        sharingHistoryVM.testsCompletion = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        self.tableView.reloadData()
    }
    
    private func runTests() {
        self.sharingHistoryVM.runTests()
    }
}

