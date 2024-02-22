package com.example.social.api;

import com.example.social.document.FollowingDocument;
import com.example.social.document.UserDocument;
import com.example.social.service.FollowingService;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/v1/following")
@RequiredArgsConstructor
public class FollowingAPI {
    private final FollowingService followingService;
    private final UserService userService;
    @PostMapping("/add")
    public ResponseEntity<FollowingDocument> insert(
            @RequestBody FollowingDocument followingDocument
    ) {
        return ResponseEntity.ok(followingService.insert(followingDocument));
    }

    @GetMapping("/get-following/{following}")
    public ResponseEntity<List<FollowingDocument>> findByFollowing(@PathVariable String following) {
        return ResponseEntity.ok(followingService.findByFollowing(following));
    }

    @GetMapping("/get-userid/{userid}")
    public ResponseEntity<List<FollowingDocument>> findByUserid(@PathVariable String userid) {
        return ResponseEntity.ok(followingService.findByUserid(userid));
    }

    @GetMapping("/get-listUserIsFollowing/{following}")
    public ResponseEntity<List<UserDocument>> getListUserISFollowing(@PathVariable String following) {
        List<FollowingDocument> list = followingService.findByFollowing(following);
        List<UserDocument> users = new ArrayList<>();
        for(FollowingDocument item : list) {
            users.add(userService.findOneById(item.getUserId()));
        }
        return ResponseEntity.ok(users);
    }

    @GetMapping("/get-listUserIsFollowed/{userid}")
    public ResponseEntity<List<UserDocument>> getListUserIsFollowed(@PathVariable String userid) {
        List<FollowingDocument> list = followingService.findByUserid(userid);
        List<UserDocument> users = new ArrayList<>();
        for(FollowingDocument item : list) {
            users.add(userService.findOneById(item.getFollowId()));
        }
        return ResponseEntity.ok(users);
    }

    @DeleteMapping("/unFollow/{userId}/{followId}")
    public void unFollow(@PathVariable String userId ,@PathVariable String followId) {
        followingService.unFollow(userId, followId);
    }
}
