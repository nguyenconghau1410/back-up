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

import java.util.ArrayList;
import java.util.List;
import java.util.Random;


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

    @GetMapping("/users/hint-user")
    public ResponseEntity<List<UserDocument>> getHintUser(@RequestParam String userid) {
        return ResponseEntity.ok(userService.recommendUser(userid));
    }

    @GetMapping("/users/hint-user-6")
    public ResponseEntity<List<UserDocument>> getHint6User(@RequestParam String userid) {
        List<UserDocument> users = userService.recommendUser(userid);
        if(users.size() > 6) {
            Random random = new Random();
            List<UserDocument> finalList = new ArrayList<>();
            int rad = random.nextInt(users.size() - 6);
            for (int i = rad - 1; i <= rad + 5; i++) {
                finalList.add(users.get(i));
            }
            return ResponseEntity.ok(finalList);
        }
        return ResponseEntity.ok(userService.recommendUser(userid));
    }

    // API ADMIN
    @GetMapping("/users/admin/get-all")
    public ResponseEntity<List<UserDocument>> getAll() {
        return ResponseEntity.ok(userService.getAll());
    }

    @DeleteMapping("/users/delete")
    public void deleteUser(@RequestParam String id) {
        userService.deleteUser(id);
    }
}
