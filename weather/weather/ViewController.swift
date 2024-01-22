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
    @IBOutlet weak var errorLabel: UILabel!

    var weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        self.descriptionLabel.isHidden=true
        self.humidityLabel.isHidden=true
        self.pressureLabel.isHidden=true
        self.temperatureLabel.isHidden=true
        self.windLabel.isHidden=true
        self.weatherMainLabel.isHidden=true
    }

    @IBAction func updateWeather(_ sender: UIButton) {
        guard let city = cityTextField.text, !city.isEmpty else {
            showError("Empty Input, Please enter any city")
            return
        }

        weatherViewModel.fetchWeatherData(for: city) { result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    self.updateUI(with: weatherModel)
                    self.hideError()
                }
            case .failure(let error):
                self.showError("Entered city didn't match")
                print("Error fetching weather data: \(error)")
            }
        }
    }

    func updateUI(with weatherModel: WeatherModel) {

        temperatureLabel.text = "Temperature: \(weatherModel.main.temp-273)°C"
        humidityLabel.text = "Humidity: \(weatherModel.main.humidity)%"
        pressureLabel.text = "Pressure: \(weatherModel.main.pressure) hPa"
        windLabel.text = "Wind Speed: \(weatherModel.wind.speed) m/s"
        weatherMainLabel.text = "Weather Main: \(weatherModel.weather[0].main)"
        descriptionLabel.text = "Description: \(weatherModel.weather[0].description)"
        self.descriptionLabel.isHidden=false
        self.humidityLabel.isHidden=false
        self.pressureLabel.isHidden=false
        self.temperatureLabel.isHidden=false
        self.windLabel.isHidden=false
        self.weatherMainLabel.isHidden=false
        
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
            self.errorLabel.isHidden = false
            self.descriptionLabel.isHidden=true
            self.humidityLabel.isHidden=true
            self.pressureLabel.isHidden=true
            self.temperatureLabel.isHidden=true
            self.windLabel.isHidden=true
            self.weatherMainLabel.isHidden=true
        }
    }


    func hideError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
}
