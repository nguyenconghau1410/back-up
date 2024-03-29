package com.example.social.service;

import com.example.social.document.Images;
import com.example.social.repository.ImagesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
@RequiredArgsConstructor
public class ImagesService {
    private final ImagesRepository imagesRepository;

    public Images insert(Images image) {
        return imagesRepository.insert(image);
    }
    public List<Images> findByUserid(String userid) {
        return imagesRepository.findByUserid(userid);
    }
}
