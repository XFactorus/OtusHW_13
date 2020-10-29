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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var suffixArrayManimulator = SuffixArrayManipulator()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configTableView()
        self.initSuffixArray()
    }
    
    // MARK: - Actions
    @IBAction func switcherChanged(_ sender: Any) {
        sortingSwitch.isOn ? sortSuffixArray(.DESC) :  sortSuffixArray(.ASC)
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("All suffixes list selected")
            self.sortAllSufixes()
        case 1:
            print("Top 3-letters suffixes list selected")
            self.sortTop3Suffixes()
        case 2:
            print("Top 5-letters suffixes list selected")
            self.sortTop5Suffixes()
        default:
            break
        }
    }
    
    // MARK: - TableView
    
    private func configTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
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
    
    // MARK: - Main methods
    
    func initSuffixArray() {
        let testItems = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
        self.suffixArrayManimulator = SuffixArrayManipulator(sentence: testItems)
        self.tableView.reloadData()
    }
    
    private func sortSuffixArray(_ sorting: ArraySortType) {
        suffixArrayManimulator.sortArray(sorting)
        sortingLabel.text = sorting.rawValue
        self.tableView.reloadData()
    }
    
    // MARK: Sorting methods
    
    private func sortAllSufixes() {
        suffixArrayManimulator.sortAllSuffixes()
        self.tableView.reloadData()
    }
    
    private func sortTop3Suffixes() {
        suffixArrayManimulator.sortTopSuffixArray(sortingLettersCount: 3)
        self.tableView.reloadData()
    }
    
    private func sortTop5Suffixes() {
        suffixArrayManimulator.sortTopSuffixArray(sortingLettersCount: 5)
        self.tableView.reloadData()
    }
}

