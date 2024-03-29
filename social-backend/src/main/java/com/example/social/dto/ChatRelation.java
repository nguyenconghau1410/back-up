package com.example.social.dto;

import com.example.social.document.ChatMessage;
import com.example.social.document.ChatRoom;
import com.example.social.document.UserDocument;
import lombok.Data;

@Data
public class ChatRelation {
    UserDocument user;
    ChatRoom chatRoom;
    ChatMessage chatMessage;
}
