package com.example.social.controller;

import com.example.social.document.ChatMessage;
import com.example.social.document.UserDocument;
import com.example.social.dto.ChatRelation;
import com.example.social.service.ChatMessageService;
import com.example.social.service.ChatRoomService;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class ChatController {
    private final SimpMessagingTemplate messagingTemplate;
    private final ChatMessageService chatMessageService;
    private final UserService userService;
    private final ChatRoomService chatRoomService;
    @MessageMapping("/chat")
    public void processMessage(@Payload ChatMessage chatMessage) {
        ChatMessage saveMsg = chatMessageService.save(chatMessage);
        ChatRelation chatRelation = new ChatRelation();
        chatRelation.setUser(userService.findOneById(saveMsg.getSenderId()));
        chatRelation.setChatMessage(saveMsg);
        chatRelation.setChatRoom(chatRoomService.getChatRoom(saveMsg.getSenderId(), saveMsg.getRecipientId()));
        messagingTemplate.convertAndSendToUser(
                chatMessage.getRecipientId(), "/queue/messages",
                chatRelation
        );
    }

    @MessageMapping("/call")
    public void processCall(@Payload Map<String, Object> mapping) {
        UserDocument sender = new UserDocument().mappingObject((Map<String, Object>) mapping.get("sender"));
        UserDocument recipient = new UserDocument().mappingObject((Map<String, Object>) mapping.get("recipient"));
        String type = (String) mapping.get("type");
        Map<String, Object> mp = new HashMap<>();
        mp.put("sender", sender);
        mp.put("recipient", recipient);
        mp.put("type", type);
        messagingTemplate.convertAndSendToUser(
                recipient.getId(), "/queue/call",
                mp
        );
    }

}
