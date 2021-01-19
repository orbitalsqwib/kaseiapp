//
//  NewItemCell.swift
//  Kasei
//
//  Created by Eugene L. on 18/11/20.
//

import UIKit

class CheckoutDetailCell: ElevatedTableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var detailContainer: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var slotPicker: UIPickerView!
    
    var slots = [String]()
    var timeIntervals = [TimeInterval]()
    
    override func awakeFromNib() {
        //Pre-initialization code
        containerView = detailContainer
        
        super.awakeFromNib()
        detailContainer.layer.cornerRadius = 10
        
        datePicker.minimumDate = tomorrowDate()
        datePicker.maximumDate = nextMonthDate()
        datePicker.datePickerMode = .date
        datePicker.calendar = .current
        slotPicker.dataSource = self
        slotPicker.delegate = self
        
        // populate available slots
        addTimeslotString(from: 8, to: 10)
        addTimeslotString(from: 10, to: 12)
        addTimeslotString(from: 12, to: 14)
        addTimeslotString(from: 14, to: 16)
        addTimeslotString(from: 16, to: 18)
        addTimeslotString(from: 18, to: 20)
    }
    
    func addTimeslotString(from start: Int, to end: Int) {
        let a = DateComponents(hour: start)
        let b = DateComponents(hour: end)
        
        let df = DateFormatter()
        df.dateFormat = "h a"
        
        let astr = df.string(from: Calendar.current.date(from: a)!)
        let bstr = df.string(from: Calendar.current.date(from: b)!)
        
        slots.append("\(astr) - \(bstr)")
        timeIntervals.append(TimeInterval(start*60*60))
    }
    
    func tomorrowDate() -> Date {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let tmrw = DateComponents(year: now.year, month: now.month, day: now.day!+1)
        
        return Calendar.current.date(from: tmrw)!
    }
    
    func nextMonthDate() -> Date {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        let nextMth = DateComponents(year: now.year, month: now.month!+1, day: now.day)
        
        return Calendar.current.date(from: nextMth)!
    }
    
    func getStartDelSlot() -> Date? {
        var date = datePicker.date
        let selected = slotPicker.selectedRow(inComponent: 0)
        let timeslot = timeIntervals[selected]
        date.addTimeInterval(timeslot)
        return date
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return slots.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return slots[row]
    }
    
    static func register(for tableView: UITableView) {
        tableView.register(UINib(nibName: "CheckoutDetailCell", bundle: nil), forCellReuseIdentifier: "checkoutDetailCell")
    }
    
    static func buildInstance(for tableView: UITableView) -> CheckoutDetailCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutDetailCell") as? CheckoutDetailCell else {
            return nil
        }
        
        return cell
    }
    
}
