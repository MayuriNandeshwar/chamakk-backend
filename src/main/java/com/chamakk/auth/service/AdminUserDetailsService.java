package com.chamakk.auth.service;

import java.util.List;
import java.util.UUID;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.chamakk.auth.entity.User;
import com.chamakk.auth.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminUserDetailsService implements UserDetailsService {

        private final UserRepository userRepository;

        @Override
        public UserDetails loadUserByUsername(String userId) {
                User user = userRepository.findById(UUID.fromString(userId))
                                .orElseThrow(() -> new UsernameNotFoundException("User not found"));

                return new org.springframework.security.core.userdetails.User(
                                user.getEmail(),
                                user.getPasswordHash(),
                                user.getIsActive(),
                                true,
                                true,
                                true,
                                List.of(new SimpleGrantedAuthority(user.getRole())));
        }

}
