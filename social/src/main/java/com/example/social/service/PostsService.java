package com.example.social.service;

import com.example.social.document.FollowingDocument;
import com.example.social.document.Images;
import com.example.social.document.PostDocument;
import com.example.social.document.UserDocument;
import com.example.social.dto.PostRelation;
import com.example.social.repository.FavorietRepository;
import com.example.social.repository.FollowingRepository;
import com.example.social.repository.PostsRepository;
import com.example.social.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PostsService {
    private final PostsRepository postsRepository;
    private final ImagesService imagesService;
    private final FollowingRepository followingRepository;
    private final UserRepository userRepository;
    private final FavorietRepository favorietRepository;
    public PostDocument insert(PostDocument postDocument) {
        if(postDocument.getImages() != null) {
            List<Images> images = new ArrayList<>();
            for(Images image : postDocument.getImages()) {
                image.setUserid(postDocument.getUserid());
                images.add(imagesService.insert(image));
            }
            postDocument.setImages(images);
        }
        return postsRepository.insert(postDocument);
    }
    public List<PostDocument> findByUserid(String userid) {
        return postsRepository.findByUserid(userid);
    }
    public Long countByUserid(String userid) {
        return postsRepository.countByUserid(userid);
    }

    public List<PostRelation> getOtherPost(String userid) {
        List<PostRelation> postRelations = new ArrayList<>();
        List<FollowingDocument> list = followingRepository.findByUserId(userid);
        for(FollowingDocument follow : list) {
            UserDocument userDocument = userRepository.findOneById(follow.getFollowId());
            List<PostDocument> posts = postsRepository.findByUserid(follow.getFollowId());
            for(PostDocument post : posts) {
                if(post.getSrc() == null) {
                    PostRelation postRelation = new PostRelation();
                    postRelation.setUser(userDocument);
                    postRelation.setPost(post);
                    postRelation.setFavorites(favorietRepository.findByPostid(post.getId()));
                    postRelations.add(postRelation);
                }
            }
        }
        Collections.sort(postRelations, new Comparator<PostRelation>() {
            @Override
            public int compare(PostRelation o1, PostRelation o2) {
                return o2.getPost().getCreatedAt().compareTo(o1.getPost().getCreatedAt());
            }
        });
        return postRelations;
    }
}
