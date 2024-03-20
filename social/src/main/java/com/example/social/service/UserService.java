package com.example.social.service;

import com.example.social.document.FollowingDocument;
import com.example.social.document.RoleDocument;
import com.example.social.document.Status;
import com.example.social.document.UserDocument;
import com.example.social.repository.RoleRepository;
import com.example.social.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final FollowingService followingService;
    public UserDocument login(UserDocument userDocument) {
        UserDocument user = userRepository.findOneByEmail(userDocument.getEmail());
        if(user != null)
            if(user.getPassword().equals(userDocument.getPassword())) {
                user.setTokenDevice(userDocument.getTokenDevice());
                userRepository.save(user);
                user.setPassword("");
                return user;
            }
        return null;
    }

    public UserDocument findOneById(String id) {
        return userRepository.findOneById(id);
    }

    public UserDocument findOneByEmail(String email) {
        return userRepository.findOneByEmail(email);
    }

    public void update(UserDocument userDocument) {
        UserDocument user = userRepository.findOneByEmail(userDocument.getEmail());
        user.setName(userDocument.getName());
        user.setDob(userDocument.getDob());
        user.setTitle(userDocument.getTitle());
        user.setGender(userDocument.isGender());
        user.setImage(userDocument.getImage());
        userRepository.save(user);
    }
    public UserDocument insert(UserDocument userDocument) {
        UserDocument user = userRepository.findOneByEmail(userDocument.getEmail());
        if(user != null) {
            return null;
        }
        RoleDocument role = roleRepository.findOneByCode("USER");
        userDocument.setRole(role);
        userDocument.setStatus(Status.OFFLINE);
        return userRepository.insert(userDocument);
    }

    public void saveUser(String email) {
        UserDocument userDocument = userRepository.findOneByEmail(email);
        userDocument.setStatus(Status.ONLINE);
        userRepository.save(userDocument);
    }

    public void disconnect(String email) {
        UserDocument userDocument = userRepository.findOneByEmail(email);
        userDocument.setStatus(Status.OFFLINE);
        userDocument.setLastOut(LocalDateTime.now().toString());
        userRepository.save(userDocument);
    }

    public List<UserDocument> findConnectedUser(String userid) {
        List<FollowingDocument> isFollowing = followingService.findByUserid(userid);
        List<UserDocument> users = new ArrayList<>();
        for(FollowingDocument follow : isFollowing) {
            UserDocument userDocument = userRepository.findOneById(follow.getFollowId());
            if(userDocument.getStatus().toString().equals("ONLINE")) {
                users.add(userDocument);
            }
        }
        return users;
    }
    public List<UserDocument> findByNameContaining(String keyword) {
        return userRepository.findByNameContaining(keyword);
    }

    public List<UserDocument> recommendUser(String userid) {
        List<FollowingDocument> follows = followingService.findByUserid(userid);
        Set<UserDocument> users = new HashSet<>();
        Set<FollowingDocument> sets = new HashSet<>();
        for(FollowingDocument follow : follows) {
            List<FollowingDocument> other = followingService.findByUserid(follow.getFollowId());
            sets.addAll(other);
        }
        for (FollowingDocument set : sets) {
            if(!set.getFollowId().equals(userid)) {
                users.add(userRepository.findById(set.getFollowId()).get());
            }
        }
        List<UserDocument> finalList = new ArrayList<>();
        for(UserDocument set : users) {
            for(FollowingDocument follow : follows) {
                if(set.getId().equals(follow.getFollowId())) {
                    finalList.add(set);
                }
            }
        }
        users.removeAll(finalList);
        return users.stream().toList();
    }
}
