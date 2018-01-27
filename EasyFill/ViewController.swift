//
//  ViewController.swift
//  EasyFill
//
//  Created by Daniel Yen on 1/27/18.
//  Copyright © 2018 Daniel Yen. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var CurrentQuestion: UILabel!
    @IBOutlet weak var canvasView: UIStackView!
    
    var path = UIBezierPath()
    var startPoint: CGPoint!
    var touchPoint: CGPoint!
    var questions = ["What is your first name?", "What is your last name?", "What is your birthday?", "How old are you?"]
    var currentNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CurrentQuestion.text = questions[0]
        saySpeech(text: questions[0])
        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tap.numberOfTapsRequired = 2;
        canvasView.addGestureRecognizer(tap)
    }

    @objc func doubleTap() {
        path.removeAllPoints()
        canvasView.layer.sublayers = nil
        canvasView.setNeedsDisplay()
        currentNumber += 1
        if(currentNumber != questions.count) {
            CurrentQuestion.text = questions[currentNumber]
            saySpeech(text: questions[currentNumber])
        } else {
            CurrentQuestion.text = "END OF QUESTIONS"
            saySpeech(text: "END OF QUESTIONS")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView) {
            startPoint = point
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let point = touch?.location(in: canvasView) {
            touchPoint = point
        }
        path.move(to: startPoint)
        path.addLine(to: touchPoint)
        startPoint = touchPoint
        draw()
    }
    
    func saySpeech(text: String) {
        let u = AVSpeechUtterance(string: text)
        u.rate = 0.5;
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(u)
    }
    
    func draw() {
        let strokeLayer = CAShapeLayer();
        strokeLayer.fillColor = nil
        strokeLayer.lineWidth = 5
        strokeLayer.strokeColor = UIColor.black.cgColor
        strokeLayer.path = path.cgPath
        canvasView.layer.addSublayer(strokeLayer)
        canvasView.setNeedsDisplay()
    }
    
}

