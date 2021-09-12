//
//  VacanciesViewController.swift
//  TestHH
//
//  Created by Mac on 12.09.2021.
//

import UIKit

class VacanciesViewController: UITableViewController {
    
    // MARK: - Public Properties
    var vacancies: [Item]? = []
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        title = "Вакансии"
        fetchData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vacancies?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var contentConfig = cell.defaultContentConfiguration()
        
        let vacancy = vacancies?[indexPath.row]
        contentConfig.text = vacancy?.name
        if let salaryFrom = vacancy?.salary?.from, let currency = vacancy?.salary?.currency  {
            contentConfig.secondaryText =  "Зарплата от: \(salaryFrom) \(currency)"
        } else {
            contentConfig.secondaryText = "Зарплата не указана"
        }
        contentConfig.image = fetchImage(indexPath: indexPath)
        contentConfig.imageProperties.maximumSize = CGSize(width: 30, height: 30)
        
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >=
                scrollView.contentSize.height -
                scrollView.frame.size.height) {
            guard !APICaller.shared.isPaginating else { return }
            tableView.tableFooterView = createSpinnerView()
            APICaller.shared.page += 1
            APICaller.shared.fetchData(pagination: true) {
                [weak self] result in
                switch result {
                case .success(let moreData):
                    self?.vacancies?.append(contentsOf: moreData.items)
                    DispatchQueue.main.async {
                        self?.tableView.tableFooterView = nil
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    // MARK: - Private Methods
    private func fetchData() {
        APICaller.shared.fetchData { [weak self] result in
            switch result {
            case .success(let data):
                self?.vacancies?.append(
                    contentsOf: data.items)
                DispatchQueue.main.async {
                self?.tableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func fetchImage(indexPath: IndexPath) -> UIImage {
        let vacancy = vacancies?[indexPath.row]
        var image = UIImage()
        if let url = vacancy?.employer?.logoUrls?.the90 {
            guard let imageURL = URL(string: url) else { return #imageLiteral(resourceName: "noImg") }
            do {
                let imageData = try Data(contentsOf: imageURL)
                image = UIImage(data: imageData) ?? #imageLiteral(resourceName: "noImg")
                return image
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            image = #imageLiteral(resourceName: "noImg")
        }
        return image
    }
    
    private func createSpinnerView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 100))
        let spinnerView = UIActivityIndicatorView()
        spinnerView.center = footerView.center
        footerView.addSubview(spinnerView)
        spinnerView.startAnimating()
        return footerView
        
    }
    
}

