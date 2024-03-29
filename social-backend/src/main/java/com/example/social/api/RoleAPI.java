package com.example.social.api;

import com.example.social.document.RoleDocument;
import com.example.social.service.RoleService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/roles")
@RequiredArgsConstructor
public class RoleAPI {
    private final RoleService roleService;


    @PostMapping("/add")
    public ResponseEntity<RoleDocument> insert(@RequestBody RoleDocument roleDocument) {
        return ResponseEntity.ok(roleService.insert(roleDocument));
    }
    @GetMapping("/find/{code}")
    public ResponseEntity<RoleDocument> findOneByCode(@PathVariable String code) {
        return ResponseEntity.ok(roleService.findOneByCode(code));
    }

}
