//
//  StarredGistsListVC.swift
//  GistsApp
//
//  Created by jvic on 29/08/24.
//

import UIKit
import Combine
import NetworkService

class FavoritesListVC: UITableViewController {
    private let viewModel: FavoritesListVM
    private var cancellables = Set<AnyCancellable>()
    private let cellID = "GistCell"

    init(viewModel: FavoritesListVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = viewModel.title
        tabBarItem.image = UIImage(systemName: "star.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GistCell.self, forCellReuseIdentifier: cellID)

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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! GistCell
        let gist = viewModel.gists[indexPath.row]

        cell.fileCountLabel.text = "\(gist.fileCount) arquivo(s)"
        cell.titleLabel.text = "\(gist.ownerLogin) / \(gist.filename)"

        cell.setPlaceholder()
        Task { @MainActor in
            cell.avatarImageView.image = await viewModel.loadGistUserAvatar(gist: gist)
        }

        return cell
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        .spacing80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(index: indexPath.row)
    }
}
