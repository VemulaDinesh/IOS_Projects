// ViewController.swift

import UIKit



class ViewController: UIViewController {
    @IBOutlet weak var temperatureLabel: UILabel!
        @IBOutlet weak var humidityLabel: UILabel!
        @IBOutlet weak var pressureLabel: UILabel!
        @IBOutlet weak var windLabel: UILabel!
        @IBOutlet weak var weatherMainLabel: UILabel!
        @IBOutlet weak var descriptionLabel: UILabel!
        @IBOutlet weak var cityTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        fetchWeatherData(for: "London") { result in
//            switch result {
//            case .success(let weatherModel):
//                print("Temperature: \(weatherModel.main.temp)")
//                print("Humidity: \(weatherModel.main.humidity)")
//                print("Pressure: \(weatherModel.main.pressure)")
//                print("Wind Speed: \(weatherModel.wind.speed)")
//                print("Weather: \(weatherModel.weather[0].main)")
//                print("Description: \(weatherModel.weather[0].description)")
//
//                // Update UI or perform additional actions with weather data
//            case .failure(let error):
//                print("Error fetching weather data: \(error)")
//            }
//        }
    }

    @IBAction func updateWeather(_ sender: UIButton) {
        guard let city = cityTextField.text else { return }
        fetchWeatherData(for: city) { result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    self.updateUI(with: weatherModel)
                }
            case .failure(let error):
                print("Error fetching weather data: \(error)")
            }
        }
    }

    func updateUI(with weatherModel: WeatherModel) {
        temperatureLabel.text = "Temperature: \(weatherModel.main.temp)°C"
        humidityLabel.text = "Humidity: \(weatherModel.main.humidity)%"
        pressureLabel.text = "Pressure: \(weatherModel.main.pressure) hPa"
        windLabel.text = "Wind Speed: \(weatherModel.wind.speed) m/s"
        weatherMainLabel.text = "Weather Main: \(weatherModel.weather[0].main)"
        descriptionLabel.text = "Description: \(weatherModel.weather[0].description)"
    }
    func fetchWeatherData(for city: String, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        let apiKey = "609208b6d272befd85b3fbcd4aaeb21f"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                completion(.failure(error))
                return
            }

            // Check if data is available
            guard let data = data else {
                print("No data received")
                let noDataError = NSError(domain: "No Data", code: 1, userInfo: nil)
                completion(.failure(noDataError))
                return
            }

            // Parse the data using JSONDecoder
            let decoder = JSONDecoder()
            do {
                let weatherModel = try decoder.decode(WeatherModel.self, from: data)
                completion(.success(weatherModel))
            } catch {
                print("Error decoding JSON: \(error)")
                completion(.failure(error))
            }
        }

        // Resume the task
        task.resume()
    }
}
