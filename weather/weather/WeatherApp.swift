import UIKit

class WeatherApp: UIViewController {
    let cityTextField = UITextField()
    let updateWeatherButton = UIButton(type: .system)
    let temperatureLabel = UILabel()
    let humidityLabel = UILabel()
    let pressureLabel = UILabel()
    let windLabel = UILabel()
    let weatherMainLabel = UILabel()
    let descriptionLabel = UILabel()
    let errorLabel = UILabel()
    let cityNameLabel = UILabel()
    let currentLocationButton = UIButton(type: .system)
    var weatherViewModel = WeatherViewModel()
      var labels = WeatherLabels()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // For testing purposes, fetch weather data on viewDidLoad
       // updateWeather(updateWeatherButton)
    }

    private func setupUI() {
        // Setting up cityTextField
        view.addSubview(cityTextField)
        cityTextField.borderStyle = .roundedRect
        cityTextField.placeholder = "Enter City"
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Setting up updateWeather button
        view.addSubview(updateWeatherButton)
        updateWeatherButton.configuration = .filled()
        updateWeatherButton.configuration?.baseBackgroundColor = .blue
        updateWeatherButton.configuration?.title = "Check Weather"
       // updateWeatherButton.setTitle("Update Weather", for: .normal)
        updateWeatherButton.addTarget(self, action: #selector(updateWeather), for: .touchUpInside)
        updateWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateWeatherButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            updateWeatherButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        // Setting up other UI elements
        //let labels = [cityNameLabel,temperatureLabel, humidityLabel, pressureLabel, windLabel, weatherMainLabel, descriptionLabel, errorLabel,]
        for label in labels {
            view.addSubview(label)
            label.numberOfLines = 0
            label.textColor = .black // Set text color as needed
            label.backgroundColor = .systemMint// Set background color as needed
        }

        // Add constraints for other UI elements
        var previousLabel: UILabel?
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
            ])

            if let previousLabel = previousLabel {
                // If there is a previous label, set top constraint to it
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 20).isActive = true
            } else {
                // If there is no previous label, set top constraint to updateWeatherButton
                label.topAnchor.constraint(equalTo: updateWeatherButton.bottomAnchor, constant: 20).isActive = true
            }

            previousLabel = label
        }
      

        // Setting up currentLocation button
        currentLocationButton.setTitle("CurrentLocation", for: .normal)
        currentLocationButton.configuration = .filled()
        currentLocationButton.configuration?.baseBackgroundColor = .orange
        currentLocationButton.configuration?.title = "CurrentLocation Weather"
        currentLocationButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
                view.addSubview(currentLocationButton)
                currentLocationButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    currentLocationButton.topAnchor.constraint(equalTo: updateWeatherButton.topAnchor),
                    currentLocationButton.leadingAnchor.constraint(equalTo: updateWeatherButton.trailingAnchor, constant: 10)
                ])

      

        

        // Hide labels initially
        labels.forEach { $0.isHidden = true }
    }

    @objc func updateWeather(_ sender: UIButton) {
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
    @objc func getLocation(_ sender: UIButton) {
        // Perform the required function after clicking the getLocation button
        weatherViewModel.fetchWeatherDataForCurrentLocation { result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    self.updateUI(with: weatherModel)
                    self.hideError()
                }
            case .failure(let error):
                self.showError("Error fetching weather data for current location:")
                print("Error fetching weather data for current location: \(error)")
            }
        }
    }

    func updateUI(with weatherModel: WeatherModel) {
        labels.temperatureLabel.text = "Temperature: \(weatherModel.main.temp-273)°C"
        labels.humidityLabel.text = "Humidity: \(weatherModel.main.humidity)%"
        labels.pressureLabel.text = "Pressure: \(weatherModel.main.pressure) hPa"
        labels.windLabel.text = "Wind Speed: \(weatherModel.wind.speed) m/s"
        labels.weatherMainLabel.text = "Weather Main: \(weatherModel.weather[0].main)"
        labels.descriptionLabel.text = "Description: \(weatherModel.weather[0].description)"
        labels.cityNameLabel.text = "City: \(weatherModel.name)"

        // Show labels
       labels.forEach { $0.isHidden = false }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.labels.forEach { $0.isHidden = true }
            self.labels.errorLabel.text = message
            self.labels.errorLabel.isHidden = false
        }
    }

    func hideError() {
        labels.errorLabel.text = nil
        labels.errorLabel.isHidden = true
    }
}
