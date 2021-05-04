//
//  HolidayRequest.swift
//  ApiRest
//
//  Created by user on 4/5/21.
//

import Foundation

enum holidayError : Error{
    case noDataAvailable
    case canNotProcessData
}

struct HolidayRequest {
    let resourceURL : URL
    let API_KEY = "b74a43b7f8a67b529b26b4db9f0799e8406956ac"
    
    init(countryCode:String) {
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy"
        let currentYear = dateFormater.string(from: date)
        
        let resourceString = "https://calendarific.com/api/v2/holidays?api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    func getHolidays (completion: @escaping(Result<[HolidayDetail], holidayError>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL) {data, _ , _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do{
                let decoder = JSONDecoder()
                let holidaysResponse = try decoder.decode(HolidayResponse.self, from: jsonData)
                let holidaysDetails = holidaysResponse.response.holidays
                completion(.success(holidaysDetails))
            }catch{
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
