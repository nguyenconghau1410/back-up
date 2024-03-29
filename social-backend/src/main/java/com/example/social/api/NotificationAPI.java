package com.example.social.api;

import com.example.social.document.Notification;
import com.example.social.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/notifications")
@RequiredArgsConstructor
public class NotificationAPI {
    private final NotificationService notificationService;

    @PostMapping("/add-notification")
    public void insertNotification(@RequestBody Notification notification) {
        notificationService.insert(notification);
    }

    @PutMapping("/mark-as-read")
    public void maskReadNotification(@RequestParam String id) {
        notificationService.markReadNotification(id);
    }

    @GetMapping("/get-notifications-of-user")
    public ResponseEntity<List<Notification>> findByUserid(@RequestParam String userid) {
        List<Notification> notifications = notificationService.findByUserid(userid);
        Collections.reverse(notifications);
        return ResponseEntity.ok(notifications);
    }
    //ADMIN
    @GetMapping("/count")
    public ResponseEntity<Map<String, Integer>> countNotRead(@RequestParam String userid) {
        Map<String, Integer> mp = new HashMap<>();
        int count = notificationService.count(userid, false);
        mp.put("count", count);
        return ResponseEntity.ok(mp);
    }
}
