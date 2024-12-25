//
//  HomeViewController.swift
//  MoviesProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 25.12.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var movieList: [Title] = [] // Initialize an empty array of movies

    @IBOutlet weak var TrandingMoviesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the UITableView
        TrandingMoviesTable.dataSource = self
        TrandingMoviesTable.delegate = self
        TrandingMoviesTable.register(TrandingMoviesTableViewCell.nib(), forCellReuseIdentifier: TrandingMoviesTableViewCell.identifier)
        
        // Fetch trending movies
        fetchTrendingMovies()
    }
    
    private func fetchTrendingMovies() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let movies):
                self?.movieList = movies
                DispatchQueue.main.async {
                    self?.TrandingMoviesTable.reloadData() // Reload table view on the main thread
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrandingMoviesTableViewCell.identifier, for: indexPath) as! TrandingMoviesTableViewCell
        
        let currentMovie = movieList[indexPath.row]
        cell.configure(with: currentMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle cell selection logic here if needed
        let selectedMovie = movieList[indexPath.row]
        
        // Navigate to a details view controller (if applicable)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        if let detailedVC = storyboard.instantiateViewController(withIdentifier: "movieDetailsVC") as? MovieDetailsPage {
//            detailedVC.configure(with: selectedMovie)
//            navigationController?.pushViewController(detailedVC, animated: true)
//        }
    }
}
