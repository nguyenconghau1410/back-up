package com.example.social.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Notification {
    private String id;
    private String userid;
    private UserDocument user;
    private String content;
    private String timestamp;
    private boolean read = false;
}
