//
//  GistsListViewController.swift
//  GistsApp
//
//  Created by jvic on 28/08/24.
//

import NetworkService
import UIKit
import Combine

class GistsListVC: UITableViewController {
    private let viewModel = GistsListVM()
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        tabBarItem.image = UIImage(systemName: "doc")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GistCell.self, forCellReuseIdentifier: "GistCell")

        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.connect()
    }

    func setupBindings() {
        viewModel.$gists
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showAlertMessage(title: "Erro", message: message)
            }
            .store(in: &cancellables)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GistCell", for: indexPath) as! GistCell
        let gist = viewModel.gists[indexPath.row]
        cell.configure(with: gist)
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        .spacing80
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.gists.count - 5 {
            viewModel.didReachEnd()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGist = viewModel.gists[indexPath.row]
        let detailVC = GistDetailVC(viewModel: GistDetailVM(gistId: selectedGist.id))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension UIViewController {
    public func showAlertMessage(title: String, message: String){
        let alertMessagePopUpBox = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
}
