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
            group.wait()
        }
        completion?(jobs)
    }
    
}
