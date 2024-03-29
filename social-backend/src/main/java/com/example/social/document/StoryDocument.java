package com.example.social.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "story")
@Data
public class StoryDocument {
    @Id
    private String id;
    private String userid;
    private String status;
    private String src_image;
    private String src_video;
    private String path;
    private String createdAt;
    private String modifiedAt;
}
