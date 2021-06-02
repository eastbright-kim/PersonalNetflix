//
//  PlayerViewController.swift
//  PersonalNetflix
//
//  Created by 김동환 on 2021/06/02.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var playBtn: UIButton!
    
    
    var player = AVPlayer()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        play()
    }
    
    @IBAction func playBtnToggled(_ sender: UIButton) {
        
        if player.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    
    func play(){
        player.play()
        self.playBtn.isSelected = true
    }
    
    func pause(){
        player.pause()
        self.playBtn.isSelected = false
    }
    
    func reset(){
        pause()
        self.player.replaceCurrentItem(with: nil)
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        reset()
        dismiss(animated: false, completion: nil)
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else {return false}
        return self.rate != 0
    }
}
