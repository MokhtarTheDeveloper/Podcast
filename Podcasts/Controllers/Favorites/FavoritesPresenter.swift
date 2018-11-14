//
//  FavoritesPresenter.swift
//  Podcasts
//
//  Created by Mokhtar on 11/14/18.
//  Copyright © 2018 Mokhtar. All rights reserved.
//

import Foundation

class FavoritesPresenter {
    
    func  getPodcasts() -> [Podcast] {
        return UserDefaults.standard.savedPodcasts()
    }
    
    func deletFaviorte(selectedIndexPath: IndexPath) {
        UserDefaults.standard.deletePodcast(podcast: getPodcasts()[selectedIndexPath.item])
    }
    
}
