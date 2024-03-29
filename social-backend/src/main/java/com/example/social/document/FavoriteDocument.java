package com.example.social.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "favorites")
@Data
public class FavoriteDocument {
    @Id
    private String id;
    private String userid;
    private String postid;
}
