//
//  ViewController.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import UIKit
import MapKit

class IncidentDetailViewController: UIViewController {

    var viewModel: IncidentDetailViewModel!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IncidentDetailCellView.self, forCellReuseIdentifier: "IncidentDetailCellView")
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
            //TODO: remove explicitly unwrapped
            viewModel?.createModelForTable(with: selectedIncident!)
            viewModel.createModelForMap(with: selectedIncident!)
            refreshUI()
        }
    }
    
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
    
    func setUpNavigationBar(){
        let button1 =  UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.turn.up.right.diamond.fill"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem  = button1
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

extension IncidentDetailViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentDetailCellView", for: indexPath) as? IncidentDetailCellView
        let cellForRow = viewModel.cellForAtRow(index: indexPath.row)
        cell?.cellViewModel = cellForRow
        return cell ?? IncidentDetailCellView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension IncidentDetailViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}


//MARK: Map Related Implementations
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
    
    func removeAnnotations(){
       
            for annotation in mapView.annotations{
                mapView.removeAnnotation(annotation)
            
        }
    }
    
    func setMapRegion(){
       
        if let latitude = viewModel.incidentDetailModelMap.latitude, let longitude = viewModel.incidentDetailModelMap.longitude{
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func addImageToAnnotationView(with imageData: Data?){
        if let imageData = imageData, let annotation = mapView.annotations.first{
            let view = mapView.view(for: annotation)
            DispatchQueue.main.async {
                view?.image = UIImage(data: imageData, scale: 4)
            }
        }
    }
    
    // MARK: Map Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
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
