//
//  ViewController.swift
//  AudioPlayerNode-WriteBuffer
//
//  Created by Bruce on 16/6/16.
//  Copyright © 2016年 Bruce. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureAudioDataOutputSampleBufferDelegate {

    lazy var engine = AVAudioEngine()
    var audioFile:AVAudioFile?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        音频文件的路径
        let path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first! as NSString
        
        let url = NSURL.init(string: path .stringByAppendingPathComponent("audio.caf"))
        //        创建音频文件对象
        audioFile = try! AVAudioFile.init(forWriting: url!, settings: [:])
        
        let input = engine.inputNode!
        input.installTapOnBus(0, bufferSize: 4096, format: input.inputFormatForBus(0), block: { (buffer, audioTime) in
//            注意获得到的是一个为添加音效的源声
            try! self.audioFile?.writeFromBuffer(buffer)
        })
        //        初始化并设置混响效果器节点
        let reverb = AVAudioUnitReverb()
        reverb.loadFactoryPreset(.MediumHall)
        reverb.wetDryMix = 80
        engine.attachNode(reverb)
        
        //        音频引擎连接节点
        engine.connect(input, to: reverb, format: audioFile!.processingFormat)
        engine.connect(reverb, to: engine.outputNode, format: audioFile!.processingFormat)
        
        
    }
    
    @IBAction func playOrStop(sender: AnyObject) {
        
        let button = sender as! UIButton

        button.selected = button.selected != true ? true:false
        button.setTitle("stop", forState: .Selected)
        
        if button.selected==true {
            print(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first)
            try! engine.start()
        }else{
            engine.inputNode?.removeTapOnBus(0)
            engine.stop()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

