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
    let getLocationButton = UIButton(type: .system)
    var weatherViewModel = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        // For testing purposes, fetch weather data on viewDidLoad
       // updateWeather(updateWeatherButton)
    }

    private func setupUI() {
        // Setting up cityTextField
        cityTextField.borderStyle = .roundedRect
        cityTextField.placeholder = "Enter City"
        view.addSubview(cityTextField)

        // Setting up updateWeather button
        updateWeatherButton.configuration = .filled()
        updateWeatherButton.configuration?.baseBackgroundColor = .blue
        updateWeatherButton.configuration?.title = "Check Weather"
       // updateWeatherButton.setTitle("Update Weather", for: .normal)
        updateWeatherButton.addTarget(self, action: #selector(updateWeather), for: .touchUpInside)
        view.addSubview(updateWeatherButton)
        updateWeatherButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            updateWeatherButton.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            updateWeatherButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        // Setting up other UI elements
        let labels = [cityNameLabel,temperatureLabel, humidityLabel, pressureLabel, windLabel, weatherMainLabel, descriptionLabel, errorLabel,]
        for label in labels {
            label.numberOfLines = 0
            label.textColor = .black // Set text color as needed
            label.backgroundColor = .systemMint// Set background color as needed
            view.addSubview(label)
        }

        // Setting up constraints
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

       
        getLocationButton.setTitle("CurrentLocation", for: .normal)
        getLocationButton.configuration = .filled()
        getLocationButton.configuration?.baseBackgroundColor = .orange
        getLocationButton.configuration?.title = "CurrentLocation Weather"
        getLocationButton.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
                view.addSubview(getLocationButton)

                getLocationButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    getLocationButton.topAnchor.constraint(equalTo: updateWeatherButton.topAnchor),
                    getLocationButton.leadingAnchor.constraint(equalTo: updateWeatherButton.trailingAnchor, constant: 10)
                ])

        var previousLabel: UILabel?

        // Add constraints for other UI elements
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
        temperatureLabel.text = "Temperature: \(weatherModel.main.temp-273)°C"
        humidityLabel.text = "Humidity: \(weatherModel.main.humidity)%"
        pressureLabel.text = "Pressure: \(weatherModel.main.pressure) hPa"
        windLabel.text = "Wind Speed: \(weatherModel.wind.speed) m/s"
        weatherMainLabel.text = "Weather Main: \(weatherModel.weather[0].main)"
        descriptionLabel.text = "Description: \(weatherModel.weather[0].description)"
        cityNameLabel.text = "City: \(weatherModel.name)"

        // Show labels
        [cityNameLabel,temperatureLabel, humidityLabel, pressureLabel, windLabel, weatherMainLabel, descriptionLabel].forEach { $0.isHidden = false }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.errorLabel.text = message
            self.errorLabel.isHidden = false

            // Hide other labels
            [self.cityNameLabel,self.temperatureLabel, self.humidityLabel, self.pressureLabel, self.windLabel, self.weatherMainLabel, self.descriptionLabel].forEach { $0.isHidden = true }
        }
    }

    func hideError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
}
