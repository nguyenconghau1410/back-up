package com.example.social.dto;

import com.example.social.document.CommentDocument;
import com.example.social.document.FavoriteDocument;
import com.example.social.document.PostDocument;
import com.example.social.document.UserDocument;
import lombok.Data;

import java.util.List;

@Data
public class PostRelation {
    private UserDocument user;
    private PostDocument post;
    private List<FavoriteDocument> favorites;
    private List<CommentDocument> comments;
}
