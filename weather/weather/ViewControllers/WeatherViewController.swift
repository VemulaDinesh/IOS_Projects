import UIKit

class WeatherViewController: UIViewController {
    let cityTextField = UITextField()
    let updateWeatherButton = UIButton(type: .system)
    let currentLocationButton = UIButton(type: .system)
    var weatherViewModel = WeatherViewModel()
    let errorLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "Weather"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .white
    }
    private func setupUI() {
        // Setting up cityTextField
        view.addSubview(cityTextField)
        cityTextField.borderStyle = .roundedRect
        cityTextField.placeholder = "Enter City"
        cityTextField.translatesAutoresizingMaskIntoConstraints = false
        cityTextField.textColor = .white
        cityTextField.layer.borderColor = UIColor.white.cgColor
        cityTextField.layer.borderWidth = 1.0
        cityTextField.layer.cornerRadius = 5.0
        if let placeholder = cityTextField.placeholder {
            cityTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }

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
        
            view.addSubview(errorLabel)
            errorLabel.numberOfLines = 0
            errorLabel.textColor = .black // Set text color as needed
            errorLabel.backgroundColor = .systemMint// Set background color as needed
        
        // Add constraints for other UI elements
       
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                errorLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
                errorLabel.topAnchor.constraint(equalTo: updateWeatherButton.bottomAnchor, constant: 50)
            ])
        errorLabel.isHidden = true
    }
//    @objc func updateWeather(_ sender: UIButton)
//    {
//        
//    }
//    @objc func getLocation(_ sender: UIButton)
//    {
//        
//    }
    @objc func updateWeather(_ sender: UIButton) {//fetch the weather details and update the UI
        guard let city = cityTextField.text, !city.isEmpty else {
            showError("Empty Input, Please enter any city")
            return
        }
           
        weatherViewModel.fetchWeatherData(for: city) { result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    let vc = ResultViewController()
                    self.hideError()
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
                    vc.configure(Weathermodel : weatherModel)
                    self.navigationController?.pushViewController(vc, animated: true)
                   
                }
            case .failure(let error):
                self.showError("Entered city didn't match")
                print("Error fetching weather data: \(error)")
            }
        }
    }
    @objc func getLocation(_ sender: UIButton) {//fetch the current location weather details and update the UI
        // Perform the required function after clicking the getLocation button
        cityTextField.text=nil
        weatherViewModel.fetchWeatherDataForCurrentLocation { result in
            switch result {
            case .success(let weatherModel):
                DispatchQueue.main.async {
                    let vc = ResultViewController()
                    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
                    vc.configure(Weathermodel : weatherModel)
                    self.hideError()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                self.showError("Error fetching weather data for current location:")
                print("Error fetching weather data for current location: \(error)")
            }
        }
    }

  

    func showError(_ message: String) {//errorlbel updation
        DispatchQueue.main.async {
          
            self.errorLabel.text = message
            self.errorLabel.isHidden = false
        }
    }

    func hideError() {//hiding the error
        errorLabel.text = nil
        errorLabel.isHidden = true
    }
}
