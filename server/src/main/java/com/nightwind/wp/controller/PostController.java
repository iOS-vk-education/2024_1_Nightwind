package com.nightwind.wp.controller;

import com.nightwind.wp.exception.MediaUploadException;
import com.nightwind.wp.service.UserService;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import com.nightwind.wp.domain.Post;
import com.nightwind.wp.domain.User;
import com.nightwind.wp.exception.NoSuchResourceException;
import com.nightwind.wp.exception.UnauthorizedException;
import com.nightwind.wp.exception.ValidationException;
import com.nightwind.wp.form.WritePostForm;
import com.nightwind.wp.service.PostService;

import jakarta.validation.Valid;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api")
public class PostController {
    private final PostService postService;
    private final UserService userService;

    public PostController(PostService postService, UserService userService) {
        this.postService = postService;
        this.userService = userService;
    }

    @GetMapping("posts")
    public List<Post> findPosts() {
        return postService.findAll();
    }

    @PostMapping("posts")
    public Post writePost(@Valid @RequestBody WritePostForm postForm, @RequestParam String jwt, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new ValidationException(bindingResult);
        }

        try {
            return postService.writePost(postForm, getUser(jwt));
        } catch (IOException e) {
            throw new MediaUploadException();
        }
    }

    @GetMapping(value={"/post/{id}"})
    public Post findPost(@PathVariable String id) {
        return getPost(id);
    }

    private Post getPost(String id) {
        try {
            Post post = postService.findById(Long.parseLong(id));

            if (post != null) {
                return post;
            }
        } catch (NumberFormatException ignored) {}

        throw new NoSuchResourceException();
    }

    private User getUser(String jwt) {
        User user = userService.findByJwt(jwt);

        if (user == null) {
            throw new UnauthorizedException();
        }

        return user;
    }
}
