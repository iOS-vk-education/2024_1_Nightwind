package com.nightwind.wp.controller;

import com.nightwind.wp.domain.Discussion;
import com.nightwind.wp.domain.Post;
import com.nightwind.wp.domain.User;
import com.nightwind.wp.exception.NoSuchResourceException;
import com.nightwind.wp.exception.UnauthorizedException;
import com.nightwind.wp.exception.ValidationException;
import com.nightwind.wp.service.DiscussionService;
import com.nightwind.wp.service.UserService;
import com.nightwind.wp.service.PostService;
import jakarta.validation.Valid;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class DiscussionController {
    private final DiscussionService discussionService;
    private final PostService postService;
    private final UserService userService;

    public DiscussionController(DiscussionService discussionService,
                                PostService postService,
                                UserService userService) {
        this.discussionService = discussionService;
        this.postService = postService;
        this.userService = userService;
    }

    @GetMapping(value={"/discussions/post/{id}"})
    public List<Discussion> findDiscussions(@PathVariable String id) {
        return discussionService.findAllByPostId(getPost(id).getId());
    }

    @PostMapping(value={"/discussions/post/{id}"})
    public Discussion writeDiscussion(@PathVariable String id,
                                      @Valid @RequestBody Discussion discussion,
                                      @RequestParam String jwt,
                                      @RequestParam(required = false) String parentDiscussionId,
                                      BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            throw new ValidationException(bindingResult);
        }

        if (parentDiscussionId != null) {
            discussion.setParentDiscussion(getDiscussion(parentDiscussionId));
        }

        discussion.setUser(getUser(jwt));
        discussion.setPost(getPost(id));

        return discussionService.writeDiscussion(discussion);
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

    private Discussion getDiscussion(String id) {
        try {
            Discussion discussion = discussionService.findById(Long.parseLong(id));

            if (discussion != null) {
                return discussion;
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
