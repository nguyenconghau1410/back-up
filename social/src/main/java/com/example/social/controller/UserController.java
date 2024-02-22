package com.example.social.controller;

import com.example.social.document.ChatNotification;
import com.example.social.document.UserDocument;
import com.example.social.service.ChatMessageService;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final SimpMessagingTemplate messagingTemplate;
    @MessageMapping("/addUser")
    public void addUser(@Payload UserDocument userDocument) {
        userService.saveUser(userDocument.getEmail());
    }
    @MessageMapping("/disconnectUser")
    public void disconnectUser(@Payload UserDocument userDocument) {
        userService.disconnect(userDocument.getEmail());
    }

}
