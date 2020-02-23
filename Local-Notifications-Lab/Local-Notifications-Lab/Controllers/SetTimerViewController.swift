//
//  ViewController.swift
//  Local-Notifications-Lab
//
//  Created by Juan Ceballos on 2/20/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit
import UserNotifications

protocol SetTimerNotificationDelegate: AnyObject    {
    func didCreateNotification(_ SetTimerNotificationDelegate: SetTimerNotificationDelegate)
}

class SetTimerViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timersButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var notificationTextField: UITextField!
    
    private let center = UNUserNotificationCenter.current()

    private let hoursData = Array(0...24)
    private let minsData = Array(0...59)
    private let secsData = Array(0...59)
    private let pickerViewRows = 10_000
    private var pickerViewMiddle: Int?
    private var pickerViewMiddleMins: Int?
    private var pickerViewMiddleSecs: Int?
    
    private var timeInterval: TimeInterval = Date().timeIntervalSinceNow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkForNotificationAuthorization()
        center.delegate = self
        
        pickerViewMiddle = ((pickerViewRows / hoursData.count) / 2) * hoursData.count
        pickerViewMiddleMins = ((pickerViewRows / minsData.count) / 2) * minsData.count
        pickerViewMiddleSecs = ((pickerViewRows / secsData.count) / 2) * secsData.count
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        self.pickerView.selectRow(pickerViewMiddle ?? 0, inComponent: 0, animated: false)
        self.pickerView.selectRow(pickerViewMiddleMins ?? 0, inComponent: 1, animated: false)
        self.pickerView.selectRow(pickerViewMiddleSecs ?? 0, inComponent: 2, animated: false)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        createLocationNotification()
        
    }
    
    private func requestNotificationsPermissions()  {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error    {
                print("error requesting authorization: \(error)")
                return
            }
            if granted  {
                print("access was granter")
            }
            else    {
                print("access denied")
            }
        }
    }
    
    private func checkForNotificationAuthorization()    {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized  {
                print("app is authorized for notifications")
            }
            else    {
                self.requestNotificationsPermissions()
            }
        }
    }
    
    private func timeConverter() -> (Int, Int, Int)   {
        let hours = pickerView.selectedRow(inComponent: 0)
        let mins = pickerView.selectedRow(inComponent: 1)
        let secsInPickerView = pickerView.selectedRow(inComponent: 2)
        
        let hoursToSeconds = (hours % hoursData.count) * 60 * 60
        let minsToSeconds = (mins % minsData.count) * 60
        let secs = (secsInPickerView % secsData.count)
        
        let timerTuple: (Int, Int, Int) = (hoursToSeconds, minsToSeconds, secs)
        
        return timerTuple
    }
    
    private func createLocationNotification()   {
        let content = UNMutableNotificationContent()
        content.title = notificationTextField.text ?? "No Title"
        content.sound = .default
        
        let identifier = UUID().uuidString
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error    {
                print("error adding request \(error)")
            }
            else    {
                print("request added")
            }
        }
        
        
    }
    
}

extension SetTimerViewController: UIPickerViewDataSource    {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerViewRows
    }
    
}

extension SetTimerViewController: UIPickerViewDelegate  {
    
    func valueForRows(component: Int, row: Int) -> Int  {
        switch  component {
        case 0:
            return hoursData[row % hoursData.count] // never goes out of range with %
        case 1:
            return minsData[row % minsData.count]
        case 2:
            return secsData[row % secsData.count]
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        valueForRows(component: component, row: row).description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component    {
        case 0:
            let newRow = (pickerViewMiddle ?? 0) + (row % hoursData.count)
            pickerView.selectRow(newRow, inComponent: component, animated: false)
        case 1:
            let newRow = (pickerViewMiddleMins ?? 0) + (row % minsData.count)
            pickerView.selectRow(newRow, inComponent: component, animated: false)
        case 2:
            let newRow = (pickerViewMiddleSecs ?? 0) + (row % secsData.count)
            pickerView.selectRow(newRow, inComponent: component, animated: false)
        default:
            break
        }
        
        timeInterval = Date().timeIntervalSinceNow + (Double((timeConverter().0 + timeConverter().1 + timeConverter().2)))
        
    }
    
}

extension SetTimerViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
}


