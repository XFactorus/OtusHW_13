import Foundation

class JobScheduler {
    
    var jobs: [JobQueue] = []
    var completion: (([JobQueue]) -> Void)?
    
    func runJobs() {
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.vladp.job.Scheduler", qos: .background)
        
        for job in jobs {
            group.enter()
            queue.async {
                job.execute()
                group.leave()
            }
        }
    
        group.notify(queue: .main) { [self] in
            print("All tasks completed")
            completion?(jobs)
        }
    }
    
}
