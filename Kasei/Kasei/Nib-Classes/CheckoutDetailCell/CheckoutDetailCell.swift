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
        slots.append(timeslotString(from: 8, to: 10))
        slots.append(timeslotString(from: 10, to: 12))
        slots.append(timeslotString(from: 12, to: 14))
        slots.append(timeslotString(from: 14, to: 16))
        slots.append(timeslotString(from: 15, to: 18))
        slots.append(timeslotString(from: 18, to: 20))
    }
    
    func timeslotString(from start: Int, to end: Int) -> String {
        let a = DateComponents(hour: start)
        let b = DateComponents(hour: end)
        
        let df = DateFormatter()
        df.dateFormat = "h a"
        
        let astr = df.string(from: Calendar.current.date(from: a)!)
        let bstr = df.string(from: Calendar.current.date(from: b)!)
        
        return "\(astr) - \(bstr)"
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
    
    func slotToTimeInterval(slot: String) -> TimeInterval? {
        if let timeSubStr = slot.split(separator: "-", maxSplits: 2, omittingEmptySubsequences: true).first {
            var timeStr = String(timeSubStr.dropLast())
            var hours = 0
            if timeStr.popLast() == "p" {
                hours += 12
            }
            timeStr = String(timeStr.dropLast())
            hours += Int(timeStr) ?? 0
            return TimeInterval(hours*60*60)
        }
        return nil
    }
    
    func getStartDelSlot() -> Date? {
        var date = datePicker.date
        let selected = slotPicker.selectedRow(inComponent: 0)
        if let timeslot = slotToTimeInterval(slot: slots[selected]) {
            date.addTimeInterval(timeslot)
            return date
        }
        return nil
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
