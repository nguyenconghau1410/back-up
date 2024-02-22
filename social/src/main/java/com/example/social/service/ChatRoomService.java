package com.example.social.service;

import com.example.social.document.ChatRoom;
import com.example.social.repository.ChatRoomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ChatRoomService {
    private final ChatRoomRepository repository;

    public List<ChatRoom> findBySenderId(String senderId) {
        return repository.findBySenderId(senderId);
    }

    public String getChatRoomId1(String senderId, String recipientId) {
        ChatRoom chatRoom = repository.findBySenderIdAndRecipientId(senderId, recipientId);
        if(chatRoom == null) {
            return null;
        }
        return chatRoom.getChatId();
    }

    public ChatRoom getChatRoom(String senderId, String recipientId) {
        return repository.findBySenderIdAndRecipientId(senderId, recipientId);
    }

    public String getChatRoomId(String senderId, String recipientId) {
        ChatRoom chatRoom = repository.findBySenderIdAndRecipientId(senderId, recipientId);
        if(chatRoom == null) {
            var chatId = createChatId(senderId, recipientId);
            return chatId;
        }
        return chatRoom.getChatId();
    }

    private String createChatId(String senderId, String recipientId) {
        var chatId= String.format("%s_%s", senderId, recipientId);
        ChatRoom senderRecipient = ChatRoom
                .builder()
                .chatId(chatId)
                .senderId(senderId)
                .recipientId(recipientId)
                .lastOut(LocalDateTime.now().toString())
                .build();

        ChatRoom recipientSender = ChatRoom
                .builder()
                .chatId(chatId)
                .senderId(recipientId)
                .recipientId(senderId)
                .lastOut(LocalDateTime.now().toString())
                .build();
        if(senderId.equals(recipientId)) {
            repository.save(senderRecipient);
        }
        else {
            repository.save(senderRecipient);
            repository.save(recipientSender);
        }
        return chatId;
    }




}
