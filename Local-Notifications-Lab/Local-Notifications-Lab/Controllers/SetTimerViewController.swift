//
//  ViewController.swift
//  Local-Notifications-Lab
//
//  Created by Juan Ceballos on 2/20/20.
//  Copyright © 2020 Juan Ceballos. All rights reserved.
//

import UIKit

class SetTimerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var timersButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIButton!
    
    private let hoursData = Array(0...24)
    private let minsData = Array(0...59)
    private let secsData = Array(0...59)
    private let pickerViewRows = 10_000
    private var pickerViewMiddle: Int?
    private var pickerViewMiddleMins: Int?
    private var pickerViewMiddleSecs: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerViewMiddle = ((pickerViewRows / hoursData.count) / 2) * hoursData.count
        pickerViewMiddleMins = ((pickerViewRows / minsData.count) / 2) * minsData.count
        pickerViewMiddleSecs = ((pickerViewRows / secsData.count) / 2) * secsData.count
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        self.pickerView.selectRow(pickerViewMiddle ?? 0, inComponent: 0, animated: false)
        self.pickerView.selectRow(pickerViewMiddleMins ?? 0, inComponent: 1, animated: false)
        self.pickerView.selectRow(pickerViewMiddleSecs ?? 0, inComponent: 2, animated: false)
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
        
    }
    
}

