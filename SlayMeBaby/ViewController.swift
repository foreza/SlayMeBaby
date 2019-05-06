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
    var playerItemURI:String?
    
    var playerIsPlaying:Bool?           //
    var playerTrackName:String?
    var playerTrackArtist:String?
    
    
    // Session management
    var roomParticipants:[String] = []
    
    
    // UI references
    @IBOutlet weak var songImageView: UIImageView!
    @IBOutlet weak var songProgress: UIProgressView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    
    
    @IBOutlet weak var PauseButton: UIButton!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var ReadyButton: UIButton!
    
    @IBOutlet weak var JoinSessionButton: UIButton!
    @IBOutlet weak var LeaveSessionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do anything else here
        initializeController();
    }
    
    func initializeController(){
        playerIsPlaying = false;            // On init, the player should not be playing
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
        
        // TODo: notify all other sessions to start playing if all of them have asset downloaded
    }
    
    // Pause the current track
    func pauseAudio(){
        player?.pause()
        
        // TODO: notify all other sessions to pause
    }
    
    
    
    // MARK: IBAction triggers
    
    // Join Session
    @IBAction func StartSlay(_ sender: Any) {
        // database_createNewListeningSession()
        DB_createNewSession()
        
    }
    
    // Leave Session
    @IBAction func EndSlay(_ sender: Any) {
        DB_getAllSessions()
    }
    
    // Ready button
    @IBAction func ButtonReady(_ sender: Any) {
        // For now, gets the hard coded ID from DB
        DB_getSongURLByID(songID: "MFuQ4Yc9HqcsYlP5wgLt")
        // Note: this will update the labels if successful
    }
    
    // Play button
    @IBAction func ButtonPlay(_ sender: Any) {
        // Checks if player playback is ready and then plays it
        getPlayerPlayBackIsReady()
    }
    
    // Pause Button
    @IBAction func ButtonPause(_ sender: Any) {
        pauseAudio();
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
    
    func DB_getSongURLByID(songID : String){
        
        let db = Firestore.firestore()
        let docRef = db.collection("songs").document(songID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                
                // Init temp vars
                let tempTitle:String?, tempArtist:String?, tempURI:String?
                
                // Retrieve values from document
                tempTitle = document.get("songName") as? String
                tempArtist = document.get("songArtist") as? String
                tempURI = document.get("uri") as? String
                
                // Call all of our setter functions (TODO: find a way to not have to force unwrap these values..)
                self.view_setSongTitle(title: tempTitle!)
                self.view_setSongArtist(artist: tempArtist!)
                self.util_setSongURI(uri: tempURI!)
                // return "hello"
            } else {
                print("Document does not exist")
                //return "bye"
            }
        }

    }
    
    // TODO: do some uri validation here
    func util_setSongURI(uri: String){
        playerItemURI = uri
        util_loadPlayerItemFromURIIntoPlayer(uri: uri)
    }
    
    func util_loadPlayerItemFromURIIntoPlayer(uri : String) {
        
        let url = URL(string: uri)       // Set the URL (hard code right now for proof of concept
        
        let playerItem:AVPlayerItem = AVPlayerItem(url: url!)                           // Set player Item to the url above
        
        player = AVPlayer(playerItem: playerItem)                                       // set player to play the player item
    }
    
    
    func view_setSongTitle(title: String){
        songName.text = title
    }
    
    func view_setSongArtist(artist: String){
        songArtist.text = artist
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
 
    
}

