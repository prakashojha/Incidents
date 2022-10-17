//
//  ViewController.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import UIKit
import MapKit

// Act as secondary view in split view controller
class IncidentDetailViewController: UIViewController {

    var viewModel: IncidentDetailViewModel!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IncidentDetailCellView.self, forCellReuseIdentifier: viewModel.cellIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
    
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        tableView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return tableView
    }()
    
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        mapView.clipsToBounds = true
        mapView.layer.cornerRadius = 10
        mapView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return mapView
    }()
    
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemGray2
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    
    var selectedIncident: IncidentCellModel? {
        didSet {
            if let selectedIncident = selectedIncident {
                viewModel?.createModelForTable(with: selectedIncident)
                viewModel.createModelForMap(with: selectedIncident)
                refreshUI()
            }
            
        }
    }
    
    // Handle delay in image loading. Annotation is updated when image is available
    var imageData: Data?{
        didSet{
            self.viewModel.incidentDetailModelMap.image = imageData
            DispatchQueue.main.async { [self] in
                self.addImageToAnnotationView(with: imageData)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray5
        setupView()
        setupConstraints()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
    }
    
    
    // WorkAround: Map icon disappears when app goes to background. Reset icon image when app comes in foreground
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.addImageToAnnotationView(with: self.viewModel.incidentDetailModelMap.image)
        
    }
    
    // handle constraints when device rotates
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if view.traitCollection.verticalSizeClass == .compact {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
    }
    
    
    init(viewModel: IncidentDetailViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    ///  Reduce Navigation Tile to smaller size when moving from Primary to Secondary Controller
    ///  Reload table and centre map around mapIconImage
    func refreshUI(){
        navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = self.selectedIncident?.title
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
            self.removeAnnotations()
            self.addAnnotation()
            self.setMapRegion()
        }
    }
    
    
    func setupView(){
        setUpNavigationBar()
        setupStackView()
        
    }
    
    ///  dummy button for map navigation
    //TODO: When clicked, open map and display path from current location to destination
    func setUpNavigationBar(){
        let mapNavigation =  UIBarButtonItem(image: UIImage(systemName: viewModel.mapIconImage), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem  = mapNavigation
    }
    
    
    func setupStackView(){
        stackView.addArrangedSubview(mapView)
        stackView.addArrangedSubview(tableView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stackView)
        
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
    }
    
}

// MARK: TableViewDataSource delegate implementations.
extension IncidentDetailViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier, for: indexPath) as? IncidentDetailCellView
        let cellForRow = viewModel.cellForAtRow(index: indexPath.row)
        cell?.cellViewModel = cellForRow
        return cell ?? IncidentDetailCellView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
}

// MARK: UITableviewDelegate Implementation
extension IncidentDetailViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


//MARK: MapViewDelegate Implementations
extension IncidentDetailViewController: MKMapViewDelegate{
    
    func createAnnotation()->MKPointAnnotation{
        let annotation = MKPointAnnotation()
        if let title = viewModel.incidentDetailModelMap.title, let latitude = viewModel.incidentDetailModelMap.latitude, let longitude = viewModel.incidentDetailModelMap.longitude {
            annotation.title = title
            annotation.coordinate = CLLocationCoordinate2D(latitude:  latitude, longitude: longitude)
        }
        return annotation
    }
    
    func addAnnotation(){
        let annotation = createAnnotation()
        mapView.addAnnotation(annotation)
    }
    
    /// Remove all the annotations. Currently only one annotation
    func removeAnnotations(){
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
    }
    
    /// Set map region around incident location.
    func setMapRegion(){
        if let latitude = viewModel.incidentDetailModelMap.latitude, let longitude = viewModel.incidentDetailModelMap.longitude{
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    ///  used when image load is delayed.
    func addImageToAnnotationView(with imageData: Data?){
        if let imageData = imageData, let annotation = mapView.annotations.first{
            let view = mapView.view(for: annotation)
            DispatchQueue.main.async {
                view?.image = UIImage(data: imageData, scale: 4)
            }
        }
    }
    
    
    // MARK: Map Delegate Implementation
    
    ///  Reuse the view for annotation view when annotation loads up again in the visible region.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = viewModel.annotationViewIdentifier
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        let imageData: Data? = viewModel.incidentDetailModelMap.image
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            if let data = imageData{
                DispatchQueue.main.async {
                    annotationView?.image = UIImage(data: data, scale: 4)
                }
                
            }
            
        } else {
            annotationView!.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        annotationView?.displayPriority = .required
        return annotationView
    }
    
}
