package com.example.social.service;

import com.example.social.document.Notification;
import com.example.social.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;

    public void insert(Notification notification) {
        notificationRepository.insert(notification);
    }

    public List<Notification> findByUserid(String userid) {
        return notificationRepository.findByUserid(userid);
    }

    public void markReadNotification(String id) {
        Notification notification = notificationRepository.findOneById(id);
        notification.setRead(true);
        notificationRepository.save(notification);
    }
}
