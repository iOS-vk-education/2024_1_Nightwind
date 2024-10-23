package com.nightwind.wp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.nightwind.wp.domain.Discussion;

import java.util.List;

public interface DiscussionRepository extends JpaRepository<Discussion, Long> {
    @Query(value = "SELECT * FROM discussion WHERE post_id=?1", nativeQuery = true)
    List<Discussion> findAllByPostId(long postId);
}
