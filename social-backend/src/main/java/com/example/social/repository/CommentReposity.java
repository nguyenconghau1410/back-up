package com.example.social.repository;

import com.example.social.document.CommentDocument;
import com.example.social.document.UserDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface CommentReposity extends MongoRepository<CommentDocument, String> {
    CommentDocument insert(CommentDocument commentDocument);
    List<CommentDocument> findByPostid(String postid);
    CommentDocument findByPostidAndId(String postId, String id);

    void deleteByPostid(String postid);

    void deleteByUser(UserDocument userDocument);
}
