//
//  ViewController.swift
//  SlayMeBaby
//
//  Created by Jason Chiu on 5/1/19.
//  Copyright © 2019 Jason Chiu. All rights reserved.
//

import UIKit
import Firebase



class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init Firebase
        FirebaseApp.configure()

    }
    
    
    func database_createNewListeningSession(){
        
        // Get the DB
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        
        // Basic session object is controlled here
        ref = db.collection("sessions").addDocument(data: [
            "inProgress": false,                        // Checks if the sessions are in progress
            "users": [],                                // Array of users (can get the count from this)
            "songUID": "MFuQ4Yc9HqcsYlP5wgLt",           // 20 digit UID of the song (00000000 will be default)
            "dateExample": Timestamp(date: Date()),
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    
    func database_getAllSessions(){
        
        // Get the DB
        let db = Firestore.firestore()
        db.collection("sessions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    @IBAction func StartSlay(_ sender: Any) {
        database_createNewListeningSession()
    }
    
    
    @IBAction func EndSlay(_ sender: Any) {
        
        database_getAllSessions()

    }
    
}

