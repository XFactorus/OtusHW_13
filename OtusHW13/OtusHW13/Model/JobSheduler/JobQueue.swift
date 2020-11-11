import Foundation

class JobQueue {
    
    var task: (() -> TimeInterval)?
    
    var executionTime: TimeInterval = 0
    
    func execute() {
        guard let task = task else { return }
        let time = task()
        executionTime = time
    }
    
}
