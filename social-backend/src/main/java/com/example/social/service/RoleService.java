package com.example.social.service;

import com.example.social.document.RoleDocument;
import com.example.social.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RoleService {
    private final RoleRepository roleRepository;

    public RoleDocument insert(RoleDocument roleDocument) {
        return roleRepository.insert(roleDocument);
    }

    public RoleDocument findOneByCode(String code) {
        return roleRepository.findOneByCode(code);
    }
}
