package com.example.social.repository;

import com.example.social.document.Status;
import com.example.social.document.UserDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface UserRepository extends MongoRepository<UserDocument, String> {
    UserDocument insert(UserDocument userDocument);
    List<UserDocument> findAllByStatus(Status status);
    UserDocument findOneByEmail(String email);
    UserDocument findOneById(String id);
    List<UserDocument> findByNameContaining(String keyword);
}
