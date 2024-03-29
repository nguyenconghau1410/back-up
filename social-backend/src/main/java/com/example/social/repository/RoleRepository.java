package com.example.social.repository;

import com.example.social.document.RoleDocument;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface RoleRepository extends MongoRepository<RoleDocument, String> {
    RoleDocument insert(RoleDocument roleDocument);
    RoleDocument findOneByCode(String code);
}
