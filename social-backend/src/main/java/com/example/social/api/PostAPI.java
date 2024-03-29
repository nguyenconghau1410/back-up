package com.example.social.api;

import com.example.social.document.FollowingDocument;
import com.example.social.document.PostDocument;
import com.example.social.document.UserDocument;
import com.example.social.dto.PostRelation;
import com.example.social.service.FavoriteService;
import com.example.social.service.FollowingService;
import com.example.social.service.PostsService;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/posts")
@RequiredArgsConstructor
public class PostAPI {
    private final PostsService postsService;
    private final FavoriteService favoriteService;
    @PostMapping("/create")
    public ResponseEntity<PostDocument> insert(@RequestBody PostDocument postDocument) {
        return ResponseEntity.ok(postsService.insert(postDocument));
    }

    @PutMapping("/editing-post")
    public void edit(@RequestBody PostDocument postDocument) {
        postsService.edit(postDocument);
    }

    @GetMapping("/get-all/post")
    public ResponseEntity<List<PostRelation>> findByUserid(@RequestParam String userid) {
        List<PostDocument> posts = postsService.findByUserid(userid);
        List<PostRelation> postRelations = new ArrayList<>();
        for(PostDocument post : posts) {
            if(post.getSrc() == null) {
                PostRelation postRelation = new PostRelation();
                postRelation.setPost(post);
                postRelation.setFavorites(favoriteService.findByPostid(post.getId()));
                postRelations.add(postRelation);
            }
        }
        return ResponseEntity.ok(postRelations);
    }

    @GetMapping("/get-all/short-cut")
    public ResponseEntity<List<PostRelation>> findByUserid1(@RequestParam String userid) {
        List<PostDocument> posts = postsService.findByUserid(userid);
        List<PostRelation> postRelations = new ArrayList<>();
        for(PostDocument post : posts) {
            if(post.getSrc() != null) {
                PostRelation postRelation = new PostRelation();
                postRelation.setPost(post);
                postRelation.setFavorites(favoriteService.findByPostid(post.getId()));
                postRelations.add(postRelation);
            }
        }
        return ResponseEntity.ok(postRelations);
    }

    @GetMapping("/count")
    public ResponseEntity<Map<String, Long>> countByUserid(@RequestParam String userid) {
        Map<String, Long> mp = new HashMap<>();
        mp.put("count", postsService.countByUserid(userid));
        return ResponseEntity.ok(mp);
    }

    @GetMapping("/get-other-post")
    public ResponseEntity<List<PostRelation>> getOtherPost(@RequestParam String userid) {
        return ResponseEntity.ok(postsService.getOtherPost(userid));
    }

    @DeleteMapping("/delete-post")
    public void delete(@RequestParam String postId) {
        postsService.delete(postId);
    }

    @GetMapping("/reels")
    public ResponseEntity<List<PostRelation>> getReels(@RequestParam String userid) {
        return ResponseEntity.ok(postsService.getReels(userid));
    }

    @PutMapping("/report")
    public void report(@RequestParam String postid, @RequestParam String userid) {
        postsService.savePost(postid, userid);
    }

    // ADMIN
    @GetMapping("/get-all")
    public ResponseEntity<List<PostDocument>> getAll() {
        return ResponseEntity.ok(postsService.getAll());
    }

    @GetMapping("/get-by-id")
    public ResponseEntity<PostRelation> getById(@RequestParam String id) {
        return ResponseEntity.ok(postsService.getById(id));
    }
}
