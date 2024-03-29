package com.example.social.service;

import com.example.social.document.*;
import com.example.social.dto.PostRelation;
import com.example.social.repository.*;
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
    private final ImagesRepository imagesRepository;
    private final FollowingRepository followingRepository;
    private final UserRepository userRepository;
    private final FavorietRepository favorietRepository;
    private final CommentReposity commentReposity;
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

    public List<PostRelation> getReels(String userid) {
        List<PostDocument> posts = postsRepository.findByNotUseridAndSrcNotNull(userid);
        List<PostRelation> postRelations = new ArrayList<>();
        for(PostDocument post: posts) {
            PostRelation postRelation = new PostRelation();
            postRelation.setPost(post);
            postRelation.setUser(userRepository.findOneById(post.getUserid()));
            postRelation.setFavorites(favorietRepository.findByPostid(post.getId()));
            postRelations.add(postRelation);
        }
        return postRelations;
    }

    public void edit(PostDocument postDocument) {
        postsRepository.save(postDocument);
    }

    public void delete(String id) {
        PostDocument post = postsRepository.findById(id).get();
        if(post.getImages() != null) {
            for(Images image : post.getImages()) {
                imagesRepository.deleteById(image.getId());
            }
        }
        favorietRepository.deleteByPostid(post.getId());
        commentReposity.deleteByPostid(post.getId());
        postsRepository.deleteById(post.getId());
    }

    public void savePost(String postid, String userid) {
        PostDocument post = postsRepository.findById(postid).get();
        post.getIds().add(userid);
        postsRepository.save(post);
    }

    //ADMIN
    public List<PostDocument> getAll() {
        return postsRepository.findAll();
    }

    public PostRelation getById(String id) {
        PostDocument postDocument = postsRepository.findById(id).get();
        if(postDocument != null) {
            PostRelation postRelation = new PostRelation();
            postRelation.setUser(userRepository.findOneById(postDocument.getUserid()));
            postRelation.setPost(postDocument);
            postRelation.setFavorites(favorietRepository.findByPostid(id));
            return postRelation;
        }
        return null;
    }

    public void deleteByUserid(String userid) {
        postsRepository.deleteByUserid(userid);
    }
}
