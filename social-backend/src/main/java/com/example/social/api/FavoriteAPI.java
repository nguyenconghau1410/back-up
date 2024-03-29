package com.example.social.api;

import com.example.social.document.FavoriteDocument;
import com.example.social.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/favorites")
@RequiredArgsConstructor
public class FavoriteAPI {
    private final FavoriteService favoriteService;

    @PostMapping("/add")
    public ResponseEntity<FavoriteDocument> insert(@RequestBody FavoriteDocument favoriteDocument) {
        return ResponseEntity.ok(favoriteService.insert(favoriteDocument));
    }
    @DeleteMapping("/delete")
    public void delete(@RequestParam String userid, @RequestParam String postid) {
        favoriteService.deleteByUserid(userid, postid);
    }

}
