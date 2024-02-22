package com.example.social.repository;

import com.example.social.document.StoryDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface StoryRepository extends MongoRepository<StoryDocument, String> {
    List<StoryDocument> findByUserid(String userid);
    StoryDocument insert(StoryDocument storyDocument);
    void deleteById(String userid);
}
