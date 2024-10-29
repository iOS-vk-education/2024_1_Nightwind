package com.nightwind.wp.controller;

import com.nightwind.wp.domain.Post;
import com.nightwind.wp.domain.User;
import com.nightwind.wp.form.WritePostForm;
import com.nightwind.wp.service.PostService;
import com.nightwind.wp.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

import static com.nightwind.wp.utils.Utils.getValidationErrors;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequestMapping("/api")
@SuppressWarnings("unused")
public class PostController {
    private final PostService postService;
    private final UserService userService;

    public PostController(PostService postService, UserService userService) {
        this.postService = postService;
        this.userService = userService;
    }

    @Operation(summary = "Retrieve all posts",
            description = "Fetches a list of all posts.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved posts")
    })
    @GetMapping("posts")
    public ResponseEntity<List<Post>> findPosts() {
        List<Post> posts = postService.findAll();
        return ResponseEntity.ok(posts);  // 200 OK
    }

    @Operation(summary = "Create a new post",
            description = "Writes a new post. Requires user authentication via JWT.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Post created successfully"),
            @ApiResponse(responseCode = "400", description = "Validation errors"),
            @ApiResponse(responseCode = "401", description = "Unauthorized access"),
            @ApiResponse(responseCode = "500", description = "Internal server error due to media upload failure")
    })
    @PostMapping("posts")
    public ResponseEntity<Object> writePost(
            @Parameter(description = "Post data to create a new post", required = true)
            @Valid @RequestBody WritePostForm postForm,

            @Parameter(description = "JWT token for user authentication", required = true)
            @RequestParam String jwt,

            BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            return ResponseEntity.badRequest().body(getValidationErrors(bindingResult));  // 400 Bad Request
        }

        User user = userService.findByJwt(jwt);
        if (user == null) {
            return ResponseEntity.status(401).build();  // 401 Unauthorized
        }

        try {
            Post createdPost = postService.writePost(postForm, user);
            return ResponseEntity.status(201).body(createdPost);  // 201 Created
        } catch (IOException e) {
            return ResponseEntity.status(500).body("Media upload failed.");  // 500 Internal Server Error
        }
    }

    @Operation(summary = "Find a post by ID",
            description = "Retrieves a specific post by its ID, incrementing its view count.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved post"),
            @ApiResponse(responseCode = "404", description = "Post not found")
    })
    @GetMapping(value = {"/post/{id}"})
    public ResponseEntity<Post> findPost(
            @Parameter(description = "ID of the post to retrieve", required = true)
            @PathVariable long id) {
        Post post = postService.getAndIncrementViewCount(id);
        if (post == null) {
            return ResponseEntity.notFound().build();  // 404 Not Found
        }
        return ResponseEntity.ok(post);  // 200 OK
    }
}
