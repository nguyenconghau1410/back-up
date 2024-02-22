package com.example.social.api;

import com.example.social.document.ChatMessage;
import com.example.social.document.ChatRoom;
import com.example.social.dto.ChatRelation;
import com.example.social.service.ChatMessageService;
import com.example.social.service.ChatRoomService;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class ChatAPI {
    private final ChatMessageService chatMessageService;
    private final ChatRoomService chatRoomService;
    private final UserService userService;
    @GetMapping("/messages/{senderId}/{recipientId}")
    public ResponseEntity<List<ChatMessage>> findChatMessages(@PathVariable String senderId,
                                                              @PathVariable String recipientId) {
        return ResponseEntity
                .ok(chatMessageService.findChatMessages(senderId, recipientId));
    }
    @GetMapping("/rooms")
    public ResponseEntity<List<ChatRelation>> findBySenderId(@RequestParam String senderId) {
        List<ChatRoom> chatRooms = chatRoomService.findBySenderId(senderId);
        List<ChatRelation> chatRelations = new ArrayList<>();
        for(ChatRoom chatRoom : chatRooms) {
            ChatRelation chatRelation = new ChatRelation();
            chatRelation.setUser(userService.findOneById(chatRoom.getRecipientId()));
            chatRelation.setChatRoom(chatRoom);
            List<ChatMessage> messages = chatMessageService.findChatMessages(chatRoom.getSenderId(), chatRoom.getRecipientId());
            chatRelation.setChatMessage(messages.get(messages.size() - 1));
            chatRelations.add(chatRelation);
        }
        Collections.sort(chatRelations, new Comparator<ChatRelation>() {
            @Override
            public int compare(ChatRelation o1, ChatRelation o2) {
                return o2.getChatMessage().getTimestamp().compareTo(o1.getChatMessage().getTimestamp());
            }
        });
        return ResponseEntity.ok(chatRelations);
    }
}
