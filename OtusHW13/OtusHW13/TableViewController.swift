//
//  ViewController.swift
//  OtusHW13
//
//  Created by Vladyslav Pokryshka on 29.10.2020.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var sortingSwitch: UISwitch!
    
    var suffixArrayManimulator = SuffixArrayManipulator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.initSuffixArray()
    }
    
    func initSuffixArray() {
        let testItems = "One Test1 Test11 Two Test2 Test22 Three Test3 Test33  Four Test4 Five Six Seven"
        self.suffixArrayManimulator = SuffixArrayManipulator(sentence: testItems)
        self.tableView.reloadData()
    }
    
    private func configTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    // MARK: TableView data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suffixArrayManimulator.getSuffixCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let suffixStruct = suffixArrayManimulator.getSuffixByIndex(indexPath.row)
        cell.textLabel?.text = String(suffixStruct.suffix)
        cell.detailTextLabel?.text = suffixStruct.appearanceCount > 1 ? String(format: "%d appearances", suffixStruct.appearanceCount) : ""
        
        return cell
    }
    
    // MARK: Actions
    @IBAction func switcherChanged(_ sender: Any) {
        sortingSwitch.isOn ? sortSuffixArray(.DESC) :  sortSuffixArray(.ASC)
    }
    
    private func sortSuffixArray(_ sorting: ArraySortType) {
        suffixArrayManimulator.sortArray(sorting)
        sortingLabel.text = sorting.rawValue
        self.tableView.reloadData()
    }
    
}

