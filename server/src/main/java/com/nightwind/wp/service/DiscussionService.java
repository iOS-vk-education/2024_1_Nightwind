package com.nightwind.wp.service;

import org.springframework.stereotype.Service;
import com.nightwind.wp.domain.Discussion;
import com.nightwind.wp.repository.DiscussionRepository;

import java.util.List;

@Service
public class DiscussionService {
    private final DiscussionRepository discussionRepository;

    public DiscussionService(DiscussionRepository discussionRepository) {
        this.discussionRepository = discussionRepository;
    }

    public Discussion findById(long id) {
        return discussionRepository.findById(id).orElse(null);
    }

    public List<Discussion> findAllByPostId(long postId) { return discussionRepository.findAllByPostId(postId); }

    public Discussion writeDiscussion(Discussion discussion) {
        return discussionRepository.save(discussion);
    }
}
