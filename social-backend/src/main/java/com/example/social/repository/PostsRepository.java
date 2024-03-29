package com.example.social.repository;

import com.example.social.document.PostDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;

import java.util.List;

public interface PostsRepository extends MongoRepository<PostDocument, String> {
    PostDocument insert(PostDocument postDocument);
    List<PostDocument> findByUserid(String userid);
    Long countByUserid(String userid);
    void deleteById(String id);

    @Query(value = "{$and: [ {userid: {$ne: ?0}}, {src: {$ne: null}} ]}")
    List<PostDocument> findByNotUseridAndSrcNotNull(String userid);

    void deleteByUserid(String userid);
}
