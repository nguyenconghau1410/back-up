package com.example.social.document;

import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Map;

@Document(collection = "user")
@Data
public class UserDocument {
    @Id
    private String id;
    private String email;
    private String name;
    private String password;
    private String dob;
    private boolean gender;
    private String title;
    private String image;
    private Status status;
    private String lastOut;
    private String tokenDevice;
    private RoleDocument role;

    public UserDocument mappingObject(Map<String, Object> data) {
        UserDocument userDocument = new UserDocument();
        userDocument.setId((String) data.get("id"));
        userDocument.setEmail((String) data.get("email"));
        userDocument.setName((String) data.get("name"));
        userDocument.setPassword((String) data.get("password"));
        userDocument.setDob((String) data.get("dob"));
        userDocument.setGender((boolean) data.get("gender"));
        userDocument.setTitle((String) data.get("title"));
        userDocument.setImage((String) data.get("image"));
        userDocument.setLastOut((String) data.get("lastOut"));
        userDocument.setTokenDevice((String) data.get("tokenDevice"));
        return userDocument;
    }
}
