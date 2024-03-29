package com.example.social.service;

import com.example.social.document.FavoriteDocument;
import com.example.social.repository.FavorietRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FavoriteService {
    private final FavorietRepository favorietRepository;

    public FavoriteDocument insert(FavoriteDocument favoriteDocument) {
        return favorietRepository.insert(favoriteDocument);
    }

    public void deleteByUserid(String userid, String postid) {
        favorietRepository.deleteByUseridAndPostid(userid, postid);
    }

    public List<FavoriteDocument> findByPostid(String postid) {
        return favorietRepository.findByPostid(postid);
    }
}
