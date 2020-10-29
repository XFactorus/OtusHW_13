//
//  SuffixArrayManipulator.swift
//  OtusHW13


import Foundation

enum ArraySortType: String {
    case ASC
    case DESC
}

class SuffixArrayManipulator {

    private var sequenceArray: [SuffixSequence] = [SuffixSequence]()
    private var suffixArray: [SuffixStruct] = [SuffixStruct]()
   
    required init(sentence: String? = nil) {
        self.prepareSuffixArray(initialSentence: sentence)
    }
    
    public func getSuffixCount() -> Int {
        return suffixArray.count
    }
    
    public func getSuffixList() -> [SuffixStruct] {
        return self.suffixArray
    }
    
    public func getSuffixByIndex(_ index: Int) -> SuffixStruct {
        return suffixArray[index]
    }
    
    private func prepareSuffixArray(initialSentence: String?) {
        
        guard let initialSentence = initialSentence else {
            sequenceArray = [SuffixSequence]()
            suffixArray = [SuffixStruct]()
            return
        }
        
        let wordsArray = initialSentence.components(separatedBy: " ")
        
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
        
        self.sortArray(.DESC)
    }
    
    
    func sortArray(_ sortingType: ArraySortType) {
        switch sortingType {
        case .ASC:
            print("ASC array sorting")
            
            suffixArray.sort {
                $0.suffix > $1.suffix
            }
        case .DESC:
            print("DESC array sorting")
            suffixArray.sort {
                $0.suffix < $1.suffix
            }
        }
    }
    
    private func addSuffix(_ suffix: Substring) {
        if let oldSuffixIndex = self.suffixArray.firstIndex(where:{$0.suffix == suffix}) {
            suffixArray[oldSuffixIndex].appearanceCount += 1
        } else {
            suffixArray.append(SuffixStruct(suffix: suffix))
        }
     }
    
    
}
