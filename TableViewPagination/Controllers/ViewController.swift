//
//  ViewController.swift
//  TableViewPagination
//
//  Created by Pulkit Dhirana on 24/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    public static var pageNumber: Int = 1
    
    private var data: [PostModel] = [PostModel]()

    private let tableView: UITableView = {
       let table = UITableView()
       table.translatesAutoresizingMaskIntoConstraints = false
       table.isPagingEnabled = true
       table.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
       return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Posts"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        initialiseData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func initialiseData() {
        APICaller.shared.fetchData {[weak self] result in
            switch result {
            case .success(let postmodels):
                self?.data.append(contentsOf: postmodels)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinnerView = UIActivityIndicatorView()
        footerView.addSubview(spinnerView)
        spinnerView.startAnimating()
        return spinnerView
    }
}
//MARK: - TableView Delegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(NewPageViewController(), animated: true)
    }
}
//MARK: - ScrollView Delegate Methods
extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > (tableView.contentSize.height - 300 - scrollView.frame.size.height) {
            
            
            
            ViewController.pageNumber += 1
            
            guard !APICaller.shared.isPaginating else {
                // We are already fetching more data
                return
            }
            
            tableView.tableFooterView = createSpinnerFooter()
            
            APICaller.shared.fetchData(pagination: true, pageNumber: ViewController.pageNumber) {[weak self] result in
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
                    self?.tableView.tableFooterView = nil
                }
                switch result {
                case .success(let moreData):
                    self?.data.append(contentsOf: moreData)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    guard let listSize = self?.data.count else {
                        return
                    }
                    print("\(listSize) list size")
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {[weak self] in
                self?.tableView.tableFooterView = nil
            }
        }
    }
}
