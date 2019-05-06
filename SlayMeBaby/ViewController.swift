//
//  ViewController.swift
//  SlayMeBaby
//
//  Created by Jason Chiu on 5/1/19.
//  Copyright © 2019 Jason Chiu. All rights reserved.
//

import UIKit
import Firebase
import AVKit
import AVFoundation



class ViewController: UIViewController {
    
    var player:AVPlayer?                // Our Audio Player
    var playerItem:AVPlayerItem?        // Our chosen item to play
    
    var playerIsPlaying:Bool?           //
    var playerTrackName:String?
    var playerTrackArtist:String?
    
    
    // Session management
    var roomParticipants:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do anything else here
        initializeController();
    }
    
    func initializeController(){
        
        playerIsPlaying = false;            // On init, the player should not be playing
     
        loadPlayerItemIntoPlayer()
        
    }
    
    
    
    func loadPlayerItemIntoPlayer() {
        
        let url = URL(string: "http://107.170.192.117/resume/carelesswhisper.mp3")       // Set the URL (hard code right now for proof of concept
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)                           // Set player Item to the url above
        
        player = AVPlayer(playerItem: playerItem)                                       // set player to play the player item
        
        
    }
    
    
    // Function to get player's playback status (player has not yet begun playing)
    func getPlayerPlayBackIsReady(){
        
        if (player?.currentItem?.status == AVPlayerItemStatus.readyToPlay){
            print("Ready to play");
            playAudio()
        } else {
            print("Buffering");
        }
    }
    
    // Play the player's loaded track
    func playAudio(){
        player?.playImmediately(atRate: 1.0);
    }
    
    
    
    // MARK: IBAction triggers
    
    @IBAction func StartSlay(_ sender: Any) {
        // database_createNewListeningSession()
        getPlayerPlayBackIsReady()
    }
    
    
    @IBAction func EndSlay(_ sender: Any) {
        DB_getAllSessions()
    }
    
    
    
    // MARK: DATABASE OPERATIONS
    
    // DB operation to create a new listening session
    func DB_createNewSession(){
        
        // Get the DB (we don't need a strong ref to this)
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
    
    // DB operation to get all sessions
    func DB_getAllSessions(){
        
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
    
    func DB_getCurrentSessionInfo(sessionID : String) -> String {
        
        return ""
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
 
    
}

