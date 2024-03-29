package com.example.social.document;

import lombok.Data;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "images")
@Data
public class Images {
    private String id;
    private String image;
    private String userid;
}
