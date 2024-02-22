package com.example.social.service;

import com.example.social.document.CommentDocument;
import com.example.social.repository.CommentReposity;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CommentService {
    private final CommentReposity commentReposity;
    public CommentDocument insert(CommentDocument commentDocument) {
        return commentReposity.insert(commentDocument);
    }
    public List<CommentDocument> findByPostid(String postid) {
        return commentReposity.findByPostid(postid);
    }

    public void saveComment(String postId, String commentId, CommentDocument comment) {
        CommentDocument commentDocument = commentReposity.findByPostidAndId(postId, commentId);
        if(commentDocument.getReplies() == null) {
            commentDocument.setReplies(new ArrayList<>());
        }
        comment.setId(UUID.randomUUID().toString());
        commentDocument.getReplies().add(comment);
        commentReposity.save(commentDocument);
    }

}
