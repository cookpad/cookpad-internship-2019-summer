//
// Copyright © Cookpad Inc. All rights reserved.
//

import UIKit

final class LikedRecipesViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        return tableView
    }()

    private let viewModel: LikedRecipesViewModelType
    init(viewModel: LikedRecipesViewModelType = LikedRecipesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Liked Recipes"
        tabBarItem.image = UIImage(named: "tab_star_blank")
        tabBarItem.selectedImage = UIImage(named: "tab_star_fill")
    }

    private var likedRecipes: [LikesQuery.Data.Like.Node] = []
    private var hasNext: Bool = false
    private var afterRecipeID: String?

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.safeAreaLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            ])
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.registerNib(type: LikedRecipesCell.self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        viewModel.outputs.likedRecipesFetched { [weak self] likes in
            guard let self = self else { return }
            self.likedRecipes.append(contentsOf: likes.nodes?.compactMap { $0 } ?? [])
            self.hasNext = likes.pageInfo.hasNextPage
            self.afterRecipeID = likes.pageInfo.endCursor
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedRecipes = []
        hasNext = false
        afterRecipeID = nil
        viewModel.inputs.fetchLikedRecipes(after: nil)
    }
}

extension LikedRecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LikedRecipesCell.dequeue(from: tableView, for: indexPath, with: likedRecipes[indexPath.row])
        return cell
    }
}

extension LikedRecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RecipeViewController.instantiate(with: likedRecipes[indexPath.row].id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LikedRecipesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height, hasNext, let afterRecipeID = afterRecipeID {
            viewModel.inputs.fetchLikedRecipes(after: afterRecipeID)
        }
    }
}
