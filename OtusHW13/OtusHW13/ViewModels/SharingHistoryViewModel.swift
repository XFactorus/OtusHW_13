import Foundation

final class SharingHistoryViewModel {
    
    var testsCompletion: (() -> Void)?
    private var sharingsArray = [SharingModel]()

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
    
    func runTests() {
        
        let scheduler = JobScheduler()
        for sharingStruct in sharingsArray {
            let suffixBuildJob = JobQueue()
//            let suffixArrayManipuator = SuffixArrayManipulator()
            
            suffixBuildJob.task = {
                return SuffixArrayManipulator().prepareSuffixArrayWithTimer(initialSentence: sharingStruct.text)
            }
            scheduler.jobs.append(suffixBuildJob)
        }
        
        scheduler.completion = { [weak self] jobs in
            guard let strongSelf = self else { return }
//            guard strongSelf.dataSource.count >= 3 && jobs.count >= 3 else { return }
            for (index, job) in jobs.enumerated() {
//                strongSelf.dataSource[index].testResult = jobs[index].executionTime
                strongSelf.sharingsArray[index].time = job.executionTime
            }
            strongSelf.testsCompletion?()
        }
        scheduler.runJobs()
        
        
        
    }
}
