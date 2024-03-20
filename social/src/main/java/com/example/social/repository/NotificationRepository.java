package com.example.social.repository;

import com.example.social.document.Notification;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface NotificationRepository extends MongoRepository<Notification, String> {
    Notification insert(Notification notification);
    List<Notification> findByUserid(String userid);
    Notification findOneById(String id);
}
