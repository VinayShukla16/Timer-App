//
//  ViewController.swift
//  Test1
//
//  Created by Vinay Shukla on 1/2/20.
//  Copyright © 2020 Vinay Shukla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var hours: String = ""
    var minutes: String = ""
    var seconds: String = "00"
    var countDownTimer: Timer?
    var length: Int = 0
    var periodTime = "normal"
    @IBOutlet weak var TimeSelecter: UIDatePicker!
    @IBOutlet weak var labelTimer: UILabel!
    @IBAction func scrollingv2(_ sender: Any) {
        setTime()
    }
    @IBAction func initialAction(_ sender: Any){
       setTime()
    }
    @IBAction func buttonStop(_ sender: Any) {
        stop();
    }
    @IBOutlet weak var flashingBackground: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    func setTime(){
        let date = TimeSelecter.date
        let formatter = DateFormatter()

        formatter.dateFormat = "HH:mm"
        labelTimer.text = formatter.string(from: date) + ":00"
    }
    
    @IBAction func buttonStart(_ sender: Any) {
        TimeSelecter.isHidden = true
        progressBar.isHidden = false
        collectTimerData()
    }
    
    func collectTimerData(){
        let timerText = String(labelTimer.text!)
        let time : [String] = timerText.components(separatedBy: ":")
        hours = time[0]
        minutes = time[1]
        setLength(hours: Int(hours)!, minutes: Int(minutes)!)
        startTimer()
    }
    
    func startTimer(){
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
    }
    
    @objc func countDown(){
        var hourNumber:Int = Int(hours)!
        var minuteNumber:Int = Int(minutes)!
        var secondNumber:Int = Int(seconds)!
        if(hourNumber == 0 && minuteNumber == 0 && secondNumber == 0){
            if(periodTime == "break"){
                periodTime = "normal"
                countDownTimer?.invalidate()
                collectTimerData()
            }else{
                countDownTimer?.invalidate()
                breakTime();
            }
        }else if(minuteNumber == 0  && secondNumber == 0){
            hourNumber = (hourNumber) - 1
            minuteNumber = 59
            secondNumber = 69
        }else if(secondNumber == 0){
            minuteNumber = (minuteNumber) - 1
            secondNumber = 59
        }else{
            secondNumber = secondNumber - 1
        }
        
        hours = String(format: "%02d", hourNumber)
        minutes = String(format: "%02d", minuteNumber)
        seconds = String(format: "%02d", secondNumber)

        updateTimerLabel(hours: hours, minutes: minutes, seconds: seconds)
        
        flash()
    }
    
    func flash(){
        let color = flashingBackground.backgroundColor
        flashingBackground.backgroundColor = UIColor.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flashingBackground.backgroundColor = color
        }
        
        incrementProgressBar()
    }
    
    func stop(){
        updateTimerLabel(hours: "00", minutes: "00", seconds: "00")
        finish()
    }
    
    func finish(){
        TimeSelecter.isHidden = false
        progressBar.isHidden = true
        progressBar.setProgress(0, animated:false)
        
        countDownTimer!.invalidate()
    }
    
    func setLength(hours: Int, minutes: Int){
        length = 60*(60*hours + minutes)
    }
    
    func updateTimerLabel(hours: String, minutes: String, seconds: String){
        labelTimer.text = hours + ":" + minutes + ":"  + seconds
    }
    
    func incrementProgressBar(){
        let unit =
            Double(1/Double(length))
        let added = unit + Double(progressBar.progress)
       progressBar.setProgress(Float(added), animated: true)
    }
    
    func breakTime(){
        periodTime = "break"
        DispatchQueue.main.async {
            self.updateTimerLabel(hours: "00", minutes: "05", seconds: "00")
            self.hours =  String(format: "%02d", 0)
            self.minutes = String(format: "%02d", 5)
            self.seconds =  String(format: "%02d", 0)
        
            self.setLength(hours: Int(self.hours)!, minutes: Int(self.minutes)!)
            self.progressBar.setProgress(0, animated: true)
            self.flashingBackground.backgroundColor = UIColor.green
        }
        
        startTimer()
        
        
    }

    
}

