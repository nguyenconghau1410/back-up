package com.example.social.repository;

import com.example.social.document.Images;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;

public interface ImagesRepository extends MongoRepository<Images, String> {
    Images insert(Images images);
    List<Images> findByUserid(String userid);
    void deleteById(String id);
}
