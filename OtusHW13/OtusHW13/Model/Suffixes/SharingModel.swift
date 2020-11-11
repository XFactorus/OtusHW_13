import Foundation

class SharingModel {
    
    let text: String
    var time: TimeInterval = 0.0
    var isMax: Bool = false
    var isMin: Bool = false
    
    required init(text: String) {
        self.text = text
    }
    
}
