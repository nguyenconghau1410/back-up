package com.example.social.service;

import com.example.social.document.FollowingDocument;
import com.example.social.document.StoryDocument;
import com.example.social.document.UserDocument;
import com.example.social.repository.FollowingRepository;
import com.example.social.repository.StoryRepository;
import com.example.social.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class StoryService {
    private final StoryRepository storyRepository;
    private final UserRepository userRepository;
    private final FollowingRepository followingRepository;
    public List<StoryDocument> findByUserid(String userid) {
        return storyRepository.findByUserid(userid);
    }

    public StoryDocument insert(StoryDocument storyDocument) {
        return storyRepository.insert(storyDocument);
    }
    public void deleteById(String userid) {
        storyRepository.deleteById(userid);
    }

    public List<Map<String, Object>> getStoryOfFriends(String userid) {
        List<FollowingDocument> followingDocuments = followingRepository.findByUserId(userid);
        List<Map<String, Object>> mp = new ArrayList<>();
        for(FollowingDocument follow : followingDocuments) {
            UserDocument userDocument = userRepository.findOneById(follow.getFollowId());
            List<StoryDocument> stories = storyRepository.findByUserid(follow.getFollowId());
            Map<String, Object> map = new HashMap<>();
            for(StoryDocument story : stories) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS");
                LocalDateTime dateTime = LocalDateTime.parse(story.getCreatedAt(), formatter);
                LocalDateTime now = LocalDateTime.now();
                if(ChronoUnit.HOURS.between(dateTime, now) < 24) {
                    map.put("user", userDocument);
                    map.put("story", story);
                    mp.add(map);
                }
            }
        }
        return mp;
    }
}
