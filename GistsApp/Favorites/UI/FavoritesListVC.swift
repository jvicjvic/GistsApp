//
//  StarredGistsListVC.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import UIKit
import Combine

class FavoritesListVC: UITableViewController {
    private let viewModel = FavoritesListVM()
    private var cancellables = Set<AnyCancellable>()
    private let cellID = "FavoriteGistCell"

    init() {
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FavoriteGistCell.self, forCellReuseIdentifier: cellID)

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
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.gists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FavoriteGistCell
        let gist = viewModel.gists[indexPath.row]
        cell.configure(with: gist)
        return cell
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        .spacing80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGist = viewModel.gists[indexPath.row]
        let detailVC = GistDetailVC(viewModel: GistDetailVM(gistId: selectedGist.id))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
