package com.example.social.repository;

import com.example.social.document.FavoriteDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface FavorietRepository extends MongoRepository<FavoriteDocument, String> {
    FavoriteDocument insert(FavoriteDocument favoriteDocument);
    void deleteByUseridAndPostid(String userid, String postid);
    List<FavoriteDocument> findByPostid(String postid);

    void deleteByPostid(String postid);
}
