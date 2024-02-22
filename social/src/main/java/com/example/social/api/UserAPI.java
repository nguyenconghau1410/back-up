package com.example.social.api;

import com.example.social.document.UserDocument;
import com.example.social.service.FollowingService;
import com.example.social.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class UserAPI {
    private final UserService userService;
    @GetMapping("/find/{id}")
    public ResponseEntity<UserDocument> findOneById(@PathVariable String id) {
        return ResponseEntity.ok(userService.findOneById(id));
    }
    @GetMapping("/find-email/{email}")
    public ResponseEntity<UserDocument> findOneByEmail(@PathVariable String email) {
        return ResponseEntity.ok(userService.findOneByEmail(email));
    }
    @PostMapping("/auth/register")
    public ResponseEntity<UserDocument> register(@RequestBody UserDocument userDocument) {
        return ResponseEntity.ok(userService.insert(userDocument));
    }

    @PostMapping("/auth/login")
    public ResponseEntity<UserDocument> login(@RequestBody UserDocument userDocument) {
        UserDocument user = userService.login(userDocument);
        if(user != null) {
            return ResponseEntity.ok(user);
        }
        return null;
    }

    @GetMapping("/online/users")
    public ResponseEntity<List<UserDocument>> findConnectedUser(@RequestParam String userid) {

        return ResponseEntity.ok(userService.findConnectedUser(userid));
    }

    @PutMapping("/update/user")
    public void updateUser(@RequestBody UserDocument userDocument) {
        userService.update(userDocument);
    }

    @GetMapping("/users/looking-for")
    public ResponseEntity<List<UserDocument>> findByNameContainingOrTitleContaining(@RequestParam String keyword) {
        return ResponseEntity.ok(userService.findByNameContaining(keyword));
    }

}
