package com.example.social.api;

import com.example.social.document.CommentDocument;
import com.example.social.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;

@RestController
@RequestMapping("/api/v1/comments")
@RequiredArgsConstructor
public class CommentAPI {
    private final CommentService commentService;

    @PostMapping("/add-node-0")
    public ResponseEntity<CommentDocument> insert(@RequestBody CommentDocument commentDocument) {
        return ResponseEntity.ok(commentService.insert(commentDocument));
    }
    @GetMapping("get-comments")
    public ResponseEntity<List<CommentDocument>> findByPostid(@RequestParam String postid) {
        List<CommentDocument> comments = commentService.findByPostid(postid);
        Collections.reverse(comments);
        return ResponseEntity.ok(comments);
    }
    @PostMapping("/add-node-1")
    public void insert1(
            @RequestParam String postid,
            @RequestParam String commentid
            ,@RequestBody CommentDocument commentDocument) {
        commentService.saveComment(postid, commentid, commentDocument);
    }

}
