//
//  ViewController.swift
//  Nightwind
//
//  Created by Nightwind Development on 10/26/24.
//

import UIKit


class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ObservableObject {
    weak var root: TabBarViewController?
    
    @IBOutlet weak var jwtLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    
    private let userService = AppState.userService
    private let postService = AppState.postService
    private var posts: [Post] = []
    
    
    private var tableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.hidesBackButton = true
        
        if let navigationController = navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
        }
    
        
//        jwtLabel.isUserInteractionEnabled = false
//        jwtLabel.text = userService.getJwt()
        
        
        setupTableView()
        loadPosts()
    }
        
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    private func loadPosts() {
        posts = postService.getPosts()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    private func postsSeparatorSetUp(cell: UITableViewCell) {
        let postsSeparator = UIView()
        postsSeparator.backgroundColor = UIColor(Styles.Light.base)
        postsSeparator.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(postsSeparator)
        
        NSLayoutConstraint.activate([
            postsSeparator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            postsSeparator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            postsSeparator.topAnchor.constraint(equalTo: cell.bottomAnchor),
            postsSeparator.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        let topSeparator = UIView()
        topSeparator.backgroundColor = UIColor(Styles.Light.full)
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        postsSeparator.addSubview(topSeparator)
        
        NSLayoutConstraint.activate([
            topSeparator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            topSeparator.bottomAnchor.constraint(equalTo: postsSeparator.bottomAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 5)
        ])
        
        let bottomSeparator = UIView()
        bottomSeparator.backgroundColor = UIColor(Styles.Light.none)
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        postsSeparator.addSubview(bottomSeparator)
        
        NSLayoutConstraint.activate([
            bottomSeparator.leadingAnchor.constraint(equalTo: cell.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            bottomSeparator.bottomAnchor.constraint(equalTo: postsSeparator.topAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {return UITableViewCell()}
        let post = posts[indexPath.row]
        
        cell.configure(with: post)
        postsSeparatorSetUp(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        
        let controller = PostViewController()
        controller.updatePost(newPost: post)
        self.navigationController?.pushViewController(controller, animated: false)
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}

    @IBAction func signOutTouchUpInside(_ sender: UIButton) {
        userService.logout()
        jwtLabel.text = nil
        root?.root?.popTabBarView()
    }
}
