//
//  PrimaryViewController.swift
//  Incidents
//
//  Created by bindu.ojha on 12/10/22.
//

import UIKit


protocol IncidentSelectionDelegate: AnyObject {
    func incidentSelected(_ newIncident: IncidentCellModel)
    func onDataLoaded(firstData: IncidentCellModel)
    func onImageLoad(imageData: Data)
}


class IncidentListViewController: UIViewController {
    
    let viewModel: IncidentListViewModel
    weak var delegate: IncidentSelectionDelegate?
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .large
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Status"
        return searchController
        
    }()
    
    
    private var navigationBarAppearance: UINavigationBarAppearance{
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemGray5
        navigationBarAppearance.shadowColor = .clear
        return navigationBarAppearance
    }
    
    
    init(viewModel: IncidentListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        Constant.shared.iconImageWidth = self.view.frame.width < self.view.frame.height ? self.view.frame.width / 8 : self.view.frame.height / 8
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray5
        setUpViews()
        fetchData()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Ensure size of image is consistent when iPad is rotated
        Constant.shared.iconImageWidth = self.view.frame.width < self.view.frame.height ? self.view.frame.width / 8 : self.view.frame.height / 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.backgroundView = activityIndicator
        activityIndicator.startAnimating()
    }
    
    func setUpViews(){
        setupNavigationView()
        setupTableView()
        setupConstraints()
    }
    
    func passDataToDelegate(){
        let firstCellData = self.viewModel.prepareDataForDelegate(at: 0)
        self.delegate?.onDataLoaded(firstData: firstCellData)
        if let imageUrl = firstCellData.imageUrl{
            self.viewModel.getIncidentImage(imageUrl: imageUrl, handler: { data in
                if let imageData = data {
                    self.delegate?.onImageLoad(imageData: imageData)
                }
            })
        }
    }

    
    func fetchData(){
        viewModel.getIncidents()
        viewModel.onLoadData = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
                self?.passDataToDelegate()
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    func setupNavigationView(){
        setupNavigationBar()
        setUpSortBarButtons()
    }
    
    
    func setupNavigationBar(){
        navigationItem.title = "Incidents"
        navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        self.navigationItem.hidesSearchBarWhenScrolling = false
        //self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
    }
   
    
    ///Sort button added to the navigation bar
    func setUpSortBarButtons(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName :"arrow.up.arrow.down"),
                                                                 style: .done, target: self, action: #selector(onSortTapped))
        
    }
    
    @objc func onSortTapped(){
        viewModel.sort()
    }
    
    
    func setupTableView(){
        view.addSubview(tableView)
        
        tableView.register(IncidentListCellView.self, forCellReuseIdentifier: "IncidentListCellView")
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: Constant.shared.iconImageWidth, bottom: 0, right: 0)
        tableView.layoutMargins = .zero
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    @objc func pullToRefresh(){
        if let flag = tableView.refreshControl?.isRefreshing, flag == true{
            viewModel.refreshData()
            viewModel.getIncidents()
        }
        
    }
    
    
    func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}


extension IncidentListViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncidentListCellView", for: indexPath) as? IncidentListCellView
        let cellForRow = viewModel.cellForAtRow(index: indexPath.row)
        cell?.cellViewModel = cellForRow
        if let imageUrl = cellForRow.imageUrl{
            viewModel.getIncidentImage(imageUrl: imageUrl, handler: { data in
                cell?.imageData = data
            })
        }
        return cell ?? UITableViewCell()
    }
    
}


extension IncidentListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(viewModel.heightForRowAt)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCellData = viewModel.prepareDataForDelegate(at: indexPath.row)
        delegate?.incidentSelected(selectedCellData)
        if let imageUrl = selectedCellData.imageUrl{
            viewModel.getIncidentImage(imageUrl: imageUrl) { data in
                if let data = data {
                    self.delegate?.onImageLoad(imageData: data)
                }
            }
        }
    }
}


///Search entered text against categories and reload the table
extension IncidentListViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.updateSearchResults(with: searchText)
        
    }
}
