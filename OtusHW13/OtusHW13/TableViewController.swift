//
//  ViewController.swift
//  OtusHW13
//
//  Created by Vladyslav Pokryshka on 29.10.2020.
//

import UIKit
import Combine

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var sortingSwitch: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var stackView: UIStackView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var suffixArrayManipulator = SuffixArrayManipulator()

    var searchSubscriber:AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTableView()
        initSuffixArray()
        
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        
        setupSearchBarListeners()
        
    }
    
    // MARK: - Actions
    @IBAction func switcherChanged(_ sender: Any) {
        sortingSwitch.isOn ? sortSuffixArray(.DESC) :  sortSuffixArray(.ASC)
    }
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("All suffixes list selected")
            self.stackView.isHidden = false
            self.searchController.searchBar.isHidden = false
            sortAllSufixes()
        case 1:
            print("Top 3-letters suffixes list selected")
            self.stackView.isHidden = true
            self.searchController.searchBar.isHidden = true
            sortTop3Suffixes()
        case 2:
            print("Top 5-letters suffixes list selected")
            self.stackView.isHidden = true
            self.searchController.searchBar.isHidden = true
            sortTop5Suffixes()
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
        return suffixArrayManipulator.getSuffixCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let suffixStruct = suffixArrayManipulator.getSuffixByIndex(indexPath.row)
        cell.textLabel?.text = String(suffixStruct.suffix)
        cell.detailTextLabel?.text = suffixStruct.appearanceCount > 1 ? String(format: "%d appearances", suffixStruct.appearanceCount) : ""
        
        return cell
    }
    
    // MARK: - Search
    
    fileprivate func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        searchSubscriber = publisher
            .map {
                ($0.object as! UISearchTextField).text
            }
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { (str) in
                self.searchSuffix(query: str ?? "")
            }
    }
    
    fileprivate func searchSuffix(query: String) {
        suffixArrayManipulator.searchSuffix(str: query)
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        suffixArrayManipulator.clearSearch()
        self.tableView.reloadData()
    }
    
    // MARK: - Main methods
    
    func initSuffixArray() {
        
        var processedText: String!
        if let ud = UserDefaults(suiteName: "group.otusvp.shared"),
           let shareText = ud.object(forKey: "sharedText") as? String {
               processedText = shareText
        }
        else {
            processedText = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"
        }
        
        self.suffixArrayManipulator = SuffixArrayManipulator(sentence: processedText)
        self.tableView.reloadData()
    }
    
    private func sortSuffixArray(_ sorting: ArraySortType) {
        suffixArrayManipulator.sortArray(sorting)
        sortingLabel.text = sorting.rawValue
        self.tableView.reloadData()
    }
    
    // MARK: Sorting methods
    
    private func sortAllSufixes() {
        suffixArrayManipulator.sortAllSuffixes()
        self.tableView.reloadData()
    }
    
    private func sortTop3Suffixes() {
        suffixArrayManipulator.sortTopSuffixArray(sortingLettersCount: 3)
        self.tableView.reloadData()
    }
    
    private func sortTop5Suffixes() {
        suffixArrayManipulator.sortTopSuffixArray(sortingLettersCount: 5)
        self.tableView.reloadData()
    }
}

