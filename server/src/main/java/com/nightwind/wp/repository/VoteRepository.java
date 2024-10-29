package com.nightwind.wp.repository;

import com.nightwind.wp.domain.Discussion;
import com.nightwind.wp.domain.Post;
import com.nightwind.wp.domain.User;
import com.nightwind.wp.domain.Vote;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface VoteRepository extends JpaRepository<Vote, Long> {
    Optional<Vote> findByUserAndPost(User user, Post post);
    Optional<Vote> findByUserAndDiscussion(User user, Discussion discussion);
}
