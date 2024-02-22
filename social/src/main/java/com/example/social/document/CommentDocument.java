package com.example.social.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.List;

@Data
@Document(collection = "comments")
public class CommentDocument {
    @Id
    private String id;
    private UserDocument user;
    private String postid;
    private String content;
    private String src;
    private String createdAt;
//    @DBRef(lazy = false)
    private List<CommentDocument> replies;
}
