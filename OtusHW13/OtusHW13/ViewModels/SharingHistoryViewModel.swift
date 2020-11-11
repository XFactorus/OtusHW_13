import Foundation

final class SharingHistoryViewModel {
    
    var testsCompletion: (() -> Void)?
    
    private var sharingsArray = [SharingModel]()
    private var testIsActive: Bool = false
    
    func setupWithStringArray(_ stringsArray: [String]) {
        self.sharingsArray = [SharingModel]()
        for string in stringsArray {
            self.sharingsArray.append(SharingModel(text: string))
        }
    }
    
    func getElementsCount() -> Int {
        return sharingsArray.count
    }
    
    func getElementForIndex(_ index: Int) -> SharingModel? {
        guard index >= 0, index < sharingsArray.count else {return nil}
        return sharingsArray[index]
    }
    
    func runTests() -> Bool {
        
        guard testIsActive == false else {
            return false
        }
        
        let scheduler = JobScheduler()
        for sharingStruct in sharingsArray {
            let suffixBuildJob = JobQueue()
            suffixBuildJob.task = {
                return SuffixArrayManipulator().prepareSuffixArrayWithTimer(initialSentence: sharingStruct.text)
            }
            scheduler.jobs.append(suffixBuildJob)
        }
        
        scheduler.completion = { [weak self] jobs in
            guard let strongSelf = self else { return }
            for (index, job) in jobs.enumerated() {
                strongSelf.sharingsArray[index].time = job.executionTime
            }
            strongSelf.testIsActive = false
            strongSelf.findBestWorseTime()
        }
        self.testIsActive = true
        scheduler.runJobs()
        
        return true
    }
    
    func findBestWorseTime() {
        
        let minTime = self.sharingsArray.min(by: { $0.time < $1.time })?.time

        sharingsArray.filter { $0.time == minTime}[0].isMin = true
        
        if sharingsArray.count > 1 {
            let maxTime = self.sharingsArray.max(by: { $0.time < $1.time })?.time
            sharingsArray.filter { $0.time == maxTime}[0].isMax = true
        }
        self.testsCompletion?()
        
    }
}
    
