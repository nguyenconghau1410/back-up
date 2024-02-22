package com.example.social.api;

import com.example.social.document.StoryDocument;
import com.example.social.service.StoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/stories")
public class StoryAPI {
    private final StoryService storyService;

    @GetMapping("/get-all")
    public ResponseEntity<List<StoryDocument>> findByUserid(@RequestParam String userid) {
        List<StoryDocument> stories = storyService.findByUserid(userid);
        Collections.reverse(stories);
        return ResponseEntity.ok(stories);
    }
    @PostMapping("/create")
    public ResponseEntity<StoryDocument> insert(@RequestBody StoryDocument storyDocument) {
        return ResponseEntity.ok(storyService.insert(storyDocument));
    }
    @DeleteMapping("/delete")
    public void deleteById(@RequestParam String id) {
        storyService.deleteById(id);
    }

    @GetMapping("/get-story-of-friends")
    public ResponseEntity<List<Map<String, Object>>> getStoryOfFriends(@RequestParam String userid) {
        return ResponseEntity.ok(storyService.getStoryOfFriends(userid));
    }
}
