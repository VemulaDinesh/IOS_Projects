import Foundation
import UIKit

class WeatherLabels: Sequence {
    let cityNameLabel = UILabel()
    let temperatureLabel = UILabel()
    let humidityLabel = UILabel()
    let pressureLabel = UILabel()
    let windLabel = UILabel()
    let weatherMainLabel = UILabel()
    let descriptionLabel = UILabel()
    let errorLabel = UILabel()

    // Make WeatherLabels iterable
    func makeIterator() -> WeatherLabelsIterator {
        return WeatherLabelsIterator(labels: self)
    }
}

// Iterator for WeatherLabels
class WeatherLabelsIterator: IteratorProtocol {
    private let labels: WeatherLabels
    private var index = 0

    init(labels: WeatherLabels) {
        self.labels = labels
    }

    func next() -> UILabel? {
        defer { index += 1 }
        let label: UILabel?
        switch index {
        case 0: label = labels.cityNameLabel
        case 1: label = labels.temperatureLabel
        case 2: label = labels.humidityLabel
        case 3: label = labels.pressureLabel
        case 4: label = labels.windLabel
        case 5: label = labels.weatherMainLabel
        case 6: label = labels.descriptionLabel
        case 7: label = labels.errorLabel
        default: label = nil
        }
        return label
    }
}
