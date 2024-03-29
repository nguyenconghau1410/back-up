package com.example.social.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.ArrayList;
import java.util.List;

@Document(collection = "posts")
@Data
public class PostDocument {
    @Id
    private String id;
    private String userid;
    private String content;
    private String status;
    private String src;
    private String createdAt;
    private String modifiedAt;
    private List<Images> images;
    private String type;
    private String location;
    private List<String> ids = new ArrayList<>();
}
