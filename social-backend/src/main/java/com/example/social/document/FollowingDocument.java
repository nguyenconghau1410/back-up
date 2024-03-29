package com.example.social.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Data
@Document(collection = "following")
public class FollowingDocument {
    @Id
    private String id;
    private String userId;
    private String followId;
}
