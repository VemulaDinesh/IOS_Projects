// WeatherViewModel.swift
import Foundation

class WeatherViewModel {
    var weatherModel: WeatherModel?
    var errorMessage: String?

    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let apiKey = "609208b6d272befd85b3fbcd4aaeb21f"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.errorMessage = "Error fetching weather data: \(error)"
                completion(.failure(error))
                return
            }

            guard let data = data else {
                self.errorMessage = "No data received"
                let noDataError = NSError(domain: "No Data", code: 1, userInfo: nil)
                completion(.failure(noDataError))
                return
            }

            let decoder = JSONDecoder()
            do {
                let weatherModel = try decoder.decode(WeatherModel.self, from: data)
                self.weatherModel = weatherModel
                self.errorMessage = nil
                completion(.success(weatherModel))
            } catch {
                self.errorMessage = "Error decoding JSON: \(error)"
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
