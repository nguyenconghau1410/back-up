package com.example.social.api;

import com.example.social.document.Images;
import com.example.social.service.ImagesService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/images")
@RequiredArgsConstructor
public class ImageAPI {
    private final ImagesService imagesService;

    @GetMapping("/get-by-userid/{userid}")
    public ResponseEntity<List<Images>> findByUserid(@PathVariable String userid) {
        return ResponseEntity.ok(imagesService.findByUserid(userid));
    }
}
