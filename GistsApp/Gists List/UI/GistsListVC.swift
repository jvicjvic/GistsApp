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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Gists"
        tableView.register(GistCell.self, forCellReuseIdentifier: "GistCell")

        viewModel.$gists.receive(on: DispatchQueue.main).sink {_ in
            self.tableView.reloadData()
        }
        .store(in: &cancellables)

        viewModel.connect()
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
}
