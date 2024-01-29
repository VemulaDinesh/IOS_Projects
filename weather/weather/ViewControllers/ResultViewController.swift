//
//  ResultViewController.swift
//  weather
//
//  Created by Vemula Dinesh on 28/01/24.
//

import UIKit

class ResultViewController: UIViewController {
    var model : WeatherModel?
    var labels = WeatherLabels()
    override func viewDidLoad() {
        super.viewDidLoad()
     setupUI()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
        updateUI(with: model!)
    }
    func setupUI()
    {
        for label in labels {
            view.addSubview(label)
            label.numberOfLines = 0
            label.textColor = .black // Set text color as needed
            label.backgroundColor = .systemMint// Set background color as needed
        }
        var previousLabel: UILabel?
        for label in labels {
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
            ])
            
            if let previousLabel = previousLabel {
               
                label.topAnchor.constraint(equalTo: previousLabel.bottomAnchor, constant: 20).isActive = true // If there is a previous label, set top constraint to it
            } else {
                
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true// If there is no previous label, set top constraint to safe
                
            }
            previousLabel = label
            
        }
       
        let showLocationButton = UIButton(type: .system)
        view.addSubview(showLocationButton)
        showLocationButton.configuration = .filled()
        showLocationButton.configuration?.baseBackgroundColor = .blue
        showLocationButton.setTitle("Show Location", for: .normal)
        showLocationButton.addTarget(self, action: #selector(showLocation), for: .touchUpInside)
        showLocationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showLocationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //showLocationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40),
            showLocationButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -300),
            showLocationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250)
        ])
    }
    @objc func showLocation() {
        let vc = MapViewController()
        var mapModel = mapModel(city:model!.name)
        vc.configure(mapModel: mapModel)
        self.navigationController?.pushViewController(vc, animated: true)
   }
    func configure(Weathermodel : WeatherModel)
    {
        model = Weathermodel
    }
    func updateUI(with weatherModel: WeatherModel) {//UI labels update
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
  

}
