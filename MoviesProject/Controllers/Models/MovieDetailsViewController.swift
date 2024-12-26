//
//  MovieDetailsViewController.swift
//  MoviesProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 26.12.2024.
//

import UIKit
import WebKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var selectedMovie: Title? // The movie passed from the previous screen
    private var trailerURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTrailer()
    }

    private func configureUI() {
        guard let movie = selectedMovie else { return }

        // Set movie details
        titleLabel.text = movie.original_title ?? "Unknown Title"
        releaseDateLabel.text = "\(movie.release_date ?? "Unknown")"
        overviewLabel.text = movie.overview ?? "No Overview Available"
        ratingLabel.text = "\(String(format: "%.1f", movie.vote_average))"

        // Set poster image
        if let posterPath = movie.poster_path {
            let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
            posterImageView.kf.setImage(with: posterURL)
        } else {
            posterImageView.image = UIImage(systemName: "photo.artframe") // Placeholder
        }

        // Hide trailer initially
        webView.isHidden = true
    }

    private func fetchTrailer() {
            guard let movie = selectedMovie, let title = movie.original_title else { return }

            APICaller.shared.getMovie(with: title + " trailer") { [weak self] result in
                switch result {
                case .success(let videoElement):
                    DispatchQueue.main.async {
                        let videoID = videoElement.id.videoId
                        let embedHTML = """
                        <iframe width="100%" height="100%" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allowfullscreen></iframe>
                        """
                        self?.webView.loadHTMLString(embedHTML, baseURL: nil)
                        self?.webView.isHidden = false
                    }
                case .failure(let error):
                    print("Failed to fetch YouTube trailer: \(error.localizedDescription)")
                }
            }
        }

}
