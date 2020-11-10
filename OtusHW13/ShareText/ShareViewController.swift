//
//  ShareViewController.swift
//  ShareText
//
//  Created by Vladyslav Pokryshka on 31.10.2020.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        guard let text = textView.text else { return }
        
        guard let sharedDefaults = UserDefaults(suiteName: "group.otusvp.shared") else { return }
        
        var sharedStringsArray = sharedDefaults.stringArray(forKey: "sharedStringsArray") ?? [String]()
        sharedStringsArray.insert(text, at: 0)
        sharedDefaults.set(sharedStringsArray, forKey: "sharedStringsArray")
        
        let u = URL(string: "OtusVPHW13://text")
        
        if let url = u {
            _ = openURL(url)
        }
        
        dismiss(animated: false) {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }
    
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let app = responder as? UIApplication {
                return app.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
