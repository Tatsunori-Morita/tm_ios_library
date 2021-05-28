//
//  SampleCustomCodableViewController.swift
//  tm_ios_library
//
//  Created by Tatsunori on 2021/05/28.
//

import UIKit

class SampleCustomCodableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        guard let url = Bundle.main.url(forResource: "Calendar", withExtension: "json") else {
            fatalError("url not found.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("data not found.")
        }

        let decoder = JSONDecoder()
        do {
            let rootNode: RootNode = try decoder.decode(RootNode.self, from: data)
            print("result data:\(rootNode)")
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct RootNode: Codable {
    let status: String?
    let calendar: [CalendarObj]?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootCodingKey.self)
        self.status = try container.decode(String.self, forKey: .status)
        
        // キーが年月日で動的な値のためCodingKeyをyyyyMMdddで作成し、
        // 取得したノードから値を取り出してインスタンスの配列を作成
        let calendarContainer = try container.nestedContainer(keyedBy: RootCodingKey.self, forKey: .calendar)
        var _calendar: [CalendarObj] = []
        try calendarContainer.allKeys.forEach { key in
            // CodingKeyをyyyyMMddで作成し、ノードを取得
            let calendarContainer = try calendarContainer.nestedContainer(
                keyedBy: CalendarCodingKey.self, forKey: RootCodingKey(stringValue: key.stringValue)!
            )
            // Calendar以下の値を取得
            let count = try calendarContainer.decode(Int.self, forKey: CalendarCodingKey.count)
            _calendar.append(CalendarObj(date: key.stringValue, count: count))
        }
        self.calendar = _calendar
    }
    
    private struct RootCodingKey: CodingKey {
        var stringValue: String
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        var intValue: Int?
        
        init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
        
        static let status = RootCodingKey(stringValue: "status")!
        static let calendar = RootCodingKey(stringValue: "calendar")!
    }
    
    private enum CalendarCodingKey: String, CodingKey {
        case count
    }
}

struct CalendarObj: Codable {
    let date: String?
    let count: Int?
    
    init(date: String, count: Int) {
        self.date = date
        self.count = count
    }
}

