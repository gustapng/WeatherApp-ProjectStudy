//
//  Service.swift
//  Weather App
//
//  Created by Gustavo Ferreira dos Santos on 14/07/24.
//

import Foundation

struct City {
    let lat: String
    let lon: String
    let name: String
}

class Service {
    
    private let baseUrl: String = "https://api.openweathermap.org/data/3.0/onecall"
    private let apiKey: String = "APIKEY"
    private let session = URLSession.shared
    
    func fetchData(city: City, _ completion: @escaping (ForecastResponse?) -> Void) {
        let urlString = "\(baseUrl)?lat=\(city.lat)&lon=\(city.lon)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let data else {
                completion(nil)
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(ForecastResponse.self, from: data)
                completion(forecastResponse)
            } catch {
                print(error)
                completion(nil)
            }
        }
        
        task.resume()
    }
}

// MARK: - ForecastResponse
struct ForecastResponse: Codable {
    let current: Forecast
    let hourly: [Forecast]
    let daily: [DailyForecast]
}

// MARK: - Forecast
struct Forecast: Codable {
    let temp: Double
    let humidity: Int
    let windSpeed: Double
    let weather: [Weather]
    let dt: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
        case windSpeed = "wind_speed"
        case weather, dt
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - DailyForecast
struct DailyForecast: Codable {
    let dt: Int
    let temp: Temp
    let weather: [Weather]
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}


