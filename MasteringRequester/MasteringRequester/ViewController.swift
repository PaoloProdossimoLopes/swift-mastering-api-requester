//
//  ViewController.swift
//  MasteringRequester
//
//  Created by Paolo Prodossimo Lopes on 01/04/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        executeUserRequestExample()
        executeUserRequestAsyncReturnExample()
    }
    
    func executeUserRequestExample() {
        let userRequester: UserRequesterProtocol = UserRequester()
        userRequester.fetchUsers { result in
            switch result {
            case .success(let response):
                dump(response)
            case .failure(let error):
                print(error.describeError)
            }
        }
    }
    
    func executeUserRequestAsyncReturnExample() {
        let userRequester: UserRequesterProtocol = UserRequester()
        Task(priority: .background) {
            let result = await userRequester.fetchUserWithReturn()
            switch result {
            case .success(let response):
                dump(response)
            case .failure(let error):
                print(error.describeError)
            }
        }
    }
}
