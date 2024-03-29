package com.example.social.controller;

import com.example.social.document.UserDocument;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final SimpMessagingTemplate messagingTemplate;
    @MessageMapping("/addUser")
    public void addUser(@Payload UserDocument userDocument) {
        System.out.println(userDocument.getEmail());
        userService.saveUser(userDocument.getEmail());
    }
    @MessageMapping("/disconnectUser")
    public void disconnectUser(@Payload UserDocument userDocument) {
        userService.disconnect(userDocument.getEmail());
    }

}
