package com.example.social.repository;

import com.example.social.document.PostDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface PostsRepository extends MongoRepository<PostDocument, String> {
    PostDocument insert(PostDocument postDocument);
    List<PostDocument> findByUserid(String userid);
    Long countByUserid(String userid);
}
