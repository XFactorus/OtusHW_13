//
//  SuffixArrayManipulator.swift
//  OtusHW13


import Foundation

enum ArraySortType: String {
    case ASC
    case DESC
}

extension String {
    
    var lettersAndSpaces: String {
        return components(separatedBy: CharacterSet.letters.union(.whitespaces).inverted).joined()
    }
}

final class SuffixArrayManipulator {

    private var sequenceArray: [SuffixSequence] = [SuffixSequence]()
    private var allSuffixesArray: [SuffixStruct] = [SuffixStruct]()
    private var currentSuffixesArray: [SuffixStruct] = [SuffixStruct]()
    
    // MARK: Public methods
    required public init(sentence: String? = nil) {
        self.prepareSuffixArray(initialSentence: sentence)
    }
    
    public func getSuffixCount() -> Int {
        return currentSuffixesArray.count
    }
    
    public func getSuffixByIndex(_ index: Int) -> SuffixStruct {
        return currentSuffixesArray[index]
    }
    
    public func sortAllSuffixes() {
        self.currentSuffixesArray = allSuffixesArray // we can skip sorting again since we do it during array initialization (prepareSuffixArray)
    }
    
    public func sortTopSuffixArray(sortingLettersCount: Int) {
        self.currentSuffixesArray = allSuffixesArray
        self.currentSuffixesArray = allSuffixesArray.filter { currentSuffix in
            return currentSuffix.suffix.count == sortingLettersCount
        }
        
        self.currentSuffixesArray.sort {
            $0.appearanceCount > $1.appearanceCount
        }
        
        self.currentSuffixesArray = Array(currentSuffixesArray.prefix(10))
    }
    
    public func sortArray(_ sortingType: ArraySortType) {
        switch sortingType {
        case .ASC:
            print("ASC array sorting")
            
            allSuffixesArray.sort {
                $0.suffix < $1.suffix
            }
        case .DESC:
            print("DESC array sorting")
            allSuffixesArray.sort {
                $0.suffix > $1.suffix
            }
        }
        self.currentSuffixesArray = allSuffixesArray
    }
    
    
    public func searchSuffix(str: String) {
        
        guard str.trimmingCharacters(in: .whitespaces).count > 0 else {
            clearSearch()
            return
        }
        
        self.currentSuffixesArray = allSuffixesArray.filter({ (suffixStruct) -> Bool in
            return suffixStruct.suffix.lowercased().contains(str.lowercased())
        })
    }
    
    public func clearSearch() {
        self.currentSuffixesArray = allSuffixesArray
    }
    
    // MARK: Private methods
    
    private func prepareSuffixArray(initialSentence: String?) {
        
        guard let initialSentence = initialSentence else {
            sequenceArray = [SuffixSequence]()
            allSuffixesArray = [SuffixStruct]()
            return
        }
        
        
        let wordsArray = initialSentence.lettersAndSpaces.components(separatedBy: " ")
        
        for word in wordsArray {
            sequenceArray.append(SuffixSequence(string: word))
        }
        
        var suffixArray: [Substring] = [Substring]()
                
        for sequence in sequenceArray {
            for suffix in sequence {
                suffixArray.append(suffix)
                self.addSuffix(suffix)
            }
        }
        
        self.sortArray(.ASC)
        self.currentSuffixesArray = allSuffixesArray
    }
        
    private func addSuffix(_ suffix: Substring) {
        if let oldSuffixIndex = self.allSuffixesArray.firstIndex(where:{$0.suffix == suffix}) {
            allSuffixesArray[oldSuffixIndex].appearanceCount += 1
        } else {
            allSuffixesArray.append(SuffixStruct(suffix: suffix))
        }
     }
    
}
