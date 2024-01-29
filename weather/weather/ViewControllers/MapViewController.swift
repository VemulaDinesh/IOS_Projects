import UIKit
import MapKit

class MapViewController: UIViewController {
    var mapView: MKMapView!
    var viewModel = MapViewModel()
    var city:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        showLocation()
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        mapView.addGestureRecognizer(pinchGesture)
    }

    func setupMapView() {
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        
    }

     func showLocation() {
        viewModel.getCoordinates(forCity: city!) { [weak self] coordinate in
            guard let coordinate = coordinate else { return }
            self?.addPinToMapView(coordinate: coordinate)
        }
    }

    func addPinToMapView(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
    func configure(mapModel : mapModel)
    {
        self.city = mapModel.city
    }
    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
            if sender.state == .changed {
                // Get the current region span
                var region = mapView.region
                // Adjust the span based on the pinch gesture
                region.span = MKCoordinateSpan(latitudeDelta: region.span.latitudeDelta * Double(sender.scale),
                                                longitudeDelta: region.span.longitudeDelta * Double(sender.scale))
                // Set the new region
                mapView.setRegion(region, animated: false)
                // Reset the scale to avoid cumulative scaling
                sender.scale = 1.0
            }
        }
}
