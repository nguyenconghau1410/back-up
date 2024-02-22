package com.example.social.repository;

import com.example.social.document.FollowingDocument;
import com.example.social.document.UserDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface FollowingRepository extends MongoRepository<FollowingDocument, String> {
    FollowingDocument insert(FollowingDocument following);
    List<FollowingDocument> findByFollowId(String followId);
    List<FollowingDocument> findByUserId(String userId);
    FollowingDocument findOneByUserIdAndFollowId(String userId, String followId);
}
