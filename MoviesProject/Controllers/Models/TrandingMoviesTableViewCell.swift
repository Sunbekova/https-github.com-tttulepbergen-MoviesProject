//
//  TrandingMoviesTableViewCell.swift
//  MoviesProject
//
//  Created by Aisha Suanbekova Bakytjankyzy on 25.12.2024.
//

import UIKit
import Kingfisher // For image loading

class TrandingMoviesTableViewCell: UITableViewCell {
    
    static let identifier = "TrandingMoviesTableViewCell"

    @IBOutlet weak var ratingScore: UILabel!
    @IBOutlet weak var TrandingMovieTitle: UILabel!
    @IBOutlet weak var TrandingMovieImage: UIImageView!
   
    func configure(with model: Title) {
        // Set the title (use `original_title` for movies and fallback to `original_name` for TV shows)
        TrandingMovieTitle.text = model.original_title ?? model.original_name ?? "Unknown Title"
        
        ratingScore.text = "\(String(format: "%.1f", model.vote_average))"
        
        // Load the poster image
        if let posterPath = model.poster_path {
            let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") // TMDB image URL
            TrandingMovieImage.kf.setImage(with: imageURL) // Using Kingfisher
        } else {
            TrandingMovieImage.image = UIImage(systemName: "photo.artframe") // A default placeholder image
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TrandingMoviesTableViewCell", bundle: nil)
    }
}

