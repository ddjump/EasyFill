//
//  ViewController.swift
//  EasyFill
//
//  Created by Daniel Yen on 1/27/18.
//  Copyright © 2018 Daniel Yen. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var CurrentQuestion: UILabel!
    @IBOutlet weak var canvasView: UIStackView!
    
    var path = UIBezierPath()
    var startPoint: CGPoint!
    var touchPoint: CGPoint!
    var questions = ["What is your last name?", "What is your first name?", "What is your middle name?", "What is your birthday? For example 1 / 1 / 19 95", "What is your gender?", "What is your place of birth?", "What is your social security number?", "What is your email?", "What is your phone number?", "What is the mailing address?", "What is the city?", "What is the state?", "What is the zip code?", "What is the county?", "What other names you have used? Step if you dont have one."]
    var currentNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sayIntro()
        CurrentQuestion.text = questions[0]
        saySpeech(text: questions[0])
        canvasView.clipsToBounds = true
        canvasView.isMultipleTouchEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        tap.numberOfTapsRequired = 2;
        canvasView.addGestureRecognizer(tap)
    }

    @objc func doubleTap() {
        saveImage()
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
    
    func sayIntro() {
        let speech = "Hi, welcome to Easy Fill. We will read you all question from a form. Please write the answer on the i pad. Double tap to go to the next question."
        saySpeech(text: speech)
    }
    
    
    func saveImage() {
        let renderer = UIGraphicsImageRenderer(size: canvasView.bounds.size)
        let image = renderer.image { ctx in
            view.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        }
        
        let imageData = UIImagePNGRepresentation(image)!
        
        Alamofire.upload(imageData, to: "https://httpbin.org/post").responseJSON { response in
            debugPrint(response)
        }
        
        /*let authToken = "Token \(user_token!)"
        
        let headers = [
            "Authorization": authToken
        ]
        
        let parameters: Parameters = ["name": "test_place",
                                      "description": "testing image upload from swift"]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                if let image = self.imageView.image {
                    let imageData = UIImageJPEGRepresentation(image, 0.8)
                    multipartFormData.append(imageData!, withName: "image", fileName: "photo.jpg", mimeType: "jpg/png")
                }
                for (key, value) in parameters {
                    if value is String || value is Int {
                        multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                    }
                }
        },
            to: "URL",
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                    }
                case .failure(let encodingError):
                    print("encoding Error : \(encodingError)")
                }
        })*/
        
    }
    
}

