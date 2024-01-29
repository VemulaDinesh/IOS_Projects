import Foundation
import CoreLocation

class MapViewModel {
    var coordinate: CLLocationCoordinate2D?

    func getCoordinates(forCity city: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(city) { placemarks, error in
            guard error == nil,
                  let placemark = placemarks?.first,
                  let location = placemark.location else {
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
}
