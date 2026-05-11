//
//  LocationPickerViewController.swift
//  Cleanzy
//

import CoreLocation
import MapKit
import SnapKit
import UIKit

// MARK: - LocationPickerViewController

final class LocationPickerViewController: UIViewController {

    // MARK: - Callback

    /// Seçilen adres string'i döner (Mahalle, Sokak, No, İlçe, Şehir)
    var onLocationSelected: ((String) -> Void)?

    // MARK: - Private State

    private let locationManager     = CLLocationManager()
    private let geocoder            = CLGeocoder()
    private let searchCompleter     = MKLocalSearchCompleter()
    private var geocodeWorkItem:    DispatchWorkItem?
    private var searchResults:      [MKLocalSearchCompletion] = []
    private var resolvedAddress     = ""
    private var isInitialLocationSet = false

    // MARK: - Map

    private let mapView: MKMapView = {
        let mv = MKMapView()
        mv.showsUserLocation = true
        mv.showsCompass       = false
        return mv
    }()

    private let centerPinView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        iv.tintColor   = .accent
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let centerPinShadow: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        v.layer.cornerRadius = 4
        return v
    }()

    // MARK: - Search Bar

    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder            = "Adres veya konum ara…"
        sb.searchBarStyle         = .minimal
        sb.delegate               = self
        sb.autocorrectionType     = .no
        sb.autocapitalizationType = .none
        sb.backgroundColor        = .white
        sb.layer.shadowColor      = UIColor.black.cgColor
        sb.layer.shadowOpacity    = 0.08
        sb.layer.shadowRadius     = 4
        sb.layer.shadowOffset     = CGSize(width: 0, height: 2)
        return sb
    }()

    private lazy var searchResultsTable: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .white
        tv.separatorInset  = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        tv.keyboardDismissMode = .onDrag
        tv.isHidden = true
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "SearchCell")
        tv.dataSource = self
        tv.delegate   = self
        return tv
    }()

    // MARK: - Bottom Card

    private let bottomCard: UIView = {
        let v = UIView()
        v.backgroundColor    = .white
        v.layer.cornerRadius = 20
        v.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        v.layer.shadowColor   = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.12
        v.layer.shadowOffset  = CGSize(width: 0, height: -4)
        v.layer.shadowRadius  = 12
        return v
    }()

    private let locationIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "mappin.circle.fill"))
        iv.tintColor   = .accent
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let locationTitleLabel: UILabel = {
        let l = UILabel()
        l.text      = "Seçilen Konum"
        l.font      = .systemFont(ofSize: 12, weight: .semibold)
        l.textColor = .systemGray
        return l
    }()

    private let addressLabel: UILabel = {
        let l = UILabel()
        l.text          = "Haritayı kaydırarak konum seçin"
        l.font          = .systemFont(ofSize: 15, weight: .medium)
        l.textColor     = .label
        l.numberOfLines = 2
        return l
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.hidesWhenStopped = true
        return ai
    }()

    private lazy var confirmButton: UIButton = {
        let b = UIButton()
        b.setTitle("Bu Konumu Seç", for: .normal)
        b.titleLabel?.font  = .systemFont(ofSize: 16, weight: .semibold)
        b.backgroundColor   = .accent
        b.layer.cornerRadius = 14
        b.isEnabled         = false
        b.alpha             = 0.6
        b.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        return b
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupSearchCompleter()
        mapView.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - Setup

private extension LocationPickerViewController {

    func setupUI() {
        title = "Konum Seç"
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "İptal", style: .plain,
            target: self, action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .accent

        view.addSubviews([mapView, centerPinShadow, centerPinView, searchBar, searchResultsTable, bottomCard])
        bottomCard.addSubviews([locationIconView, locationTitleLabel, addressLabel, loadingIndicator, confirmButton])

        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        searchResultsTable.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(320)
        }

        bottomCard.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(180)
        }

        // Center pin — slightly above true center to look natural (pin tip on point)
        centerPinShadow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-2)
            $0.width.equalTo(18)
            $0.height.equalTo(6)
        }
        centerPinView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-24)
            $0.width.height.equalTo(48)
        }

        locationIconView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(22)
        }
        locationTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationIconView)
            $0.leading.equalTo(locationIconView.snp.trailing).offset(8)
        }
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(locationIconView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        loadingIndicator.snp.makeConstraints {
            $0.centerY.equalTo(locationTitleLabel)
            $0.leading.equalTo(locationTitleLabel.snp.trailing).offset(6)
        }
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(52)
        }
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func setupSearchCompleter() {
        searchCompleter.delegate       = self
        searchCompleter.resultTypes    = .address
    }
}

// MARK: - Actions

@objc private extension LocationPickerViewController {
    func cancelTapped() {
        dismiss(animated: true)
    }

    func confirmTapped() {
        guard !resolvedAddress.isEmpty else { return }
        onLocationSelected?(resolvedAddress)
        dismiss(animated: true)
    }
}

// MARK: - Reverse Geocoding

private extension LocationPickerViewController {
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        geocodeWorkItem?.cancel()
        loadingIndicator.startAnimating()
        addressLabel.text = "Adres alınıyor…"
        confirmButton.isEnabled = false
        confirmButton.alpha     = 0.6

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.loadingIndicator.stopAnimating()
                    if let placemark = placemarks?.first {
                        let address = self.format(placemark: placemark)
                        self.resolvedAddress = address
                        self.addressLabel.text = address
                        self.confirmButton.isEnabled = !address.isEmpty
                        self.confirmButton.alpha     = address.isEmpty ? 0.6 : 1.0
                    } else {
                        self.addressLabel.text = "Adres bulunamadı"
                    }
                }
            }
        }
        geocodeWorkItem = workItem
        // 0.6s debounce — haritayı kaydırırken sürekli istek atmayı önle
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: workItem)
    }

    func format(placemark: CLPlacemark) -> String {
        var parts: [String] = []
        if let subLocality = placemark.subLocality        { parts.append(subLocality) }       // Mahalle
        if let thoroughfare = placemark.thoroughfare       { parts.append(thoroughfare) }      // Cadde/Sokak
        if let subThoroughfare = placemark.subThoroughfare { parts.append("No:\(subThoroughfare)") } // Bina No
        if let district = placemark.subAdministrativeArea { parts.append(district) }           // İlçe
        if let city = placemark.administrativeArea         { parts.append(city) }              // Şehir
        return parts.joined(separator: ", ")
    }

    func moveMap(to coordinate: CLLocationCoordinate2D, animated: Bool = true) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(region, animated: animated)
    }
}

// MARK: - MKMapViewDelegate

extension LocationPickerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        reverseGeocode(coordinate: mapView.centerCoordinate)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationPickerViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            // İzin yoksa İstanbul'u varsayılan göster
            let istanbul = CLLocationCoordinate2D(latitude: 41.0082, longitude: 28.9784)
            moveMap(to: istanbul, animated: false)
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !isInitialLocationSet, let location = locations.first else { return }
        isInitialLocationSet = true
        moveMap(to: location.coordinate, animated: false)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationPickerViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTable.reloadData()
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        searchResults = []
        searchResultsTable.reloadData()
    }
}

// MARK: - UISearchBarDelegate

extension LocationPickerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            hideSearchResults()
        } else {
            searchCompleter.queryFragment = searchText
            showSearchResults()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        hideSearchResults()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        showSearchResults()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    private func showSearchResults() {
        searchResultsTable.isHidden = false
    }

    private func hideSearchResults() {
        searchResultsTable.isHidden = true
        searchResults = []
        searchResultsTable.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension LocationPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        let result = searchResults[indexPath.row]
        var config = cell.defaultContentConfiguration()
        config.text           = result.title
        config.secondaryText  = result.subtitle
        config.image          = UIImage(systemName: "mappin")
        config.imageProperties.tintColor = .accent
        cell.contentConfiguration = config
        return cell
    }
}

// MARK: - UITableViewDelegate

extension LocationPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let completion = searchResults[indexPath.row]

        let request = MKLocalSearch.Request(completion: completion)
        MKLocalSearch(request: request).start { [weak self] response, _ in
            guard let self, let mapItem = response?.mapItems.first else { return }
            DispatchQueue.main.async {
                self.moveMap(to: mapItem.placemark.coordinate)
                self.searchBar.text = ""
                self.searchBar.resignFirstResponder()
                self.hideSearchResults()
            }
        }
    }
}
