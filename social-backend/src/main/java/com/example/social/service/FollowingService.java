package com.example.social.service;

import com.example.social.document.FollowingDocument;
import com.example.social.document.UserDocument;
import com.example.social.repository.FollowingRepository;
import com.example.social.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class FollowingService {
    private final FollowingRepository followingRepository;
    private final UserRepository userRepository;
    public FollowingDocument insert(FollowingDocument followingDocument) {
        return followingRepository.insert(followingDocument);
    }

    public List<FollowingDocument> findByFollowing(String following) {
        return followingRepository.findByFollowId(following);
    }

    public List<FollowingDocument> findByUserid(String userid) {
        return followingRepository.findByUserId(userid);
    }

    public void unFollow(String userId,String followId) {
        FollowingDocument followingDocument = followingRepository.findOneByUserIdAndFollowId(userId, followId);
        followingRepository.delete(followingDocument);
    }
}
