package com.nightwind.wp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.nightwind.wp.domain.Post;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PostRepository extends JpaRepository<Post, Long> {
    List<Post> findAllByOrderByCreationTimeDesc();

    @Query(value = "SELECT * FROM post WHERE user_id=?1", nativeQuery = true)
    List<Post> findAllByUserId(Long userId);
}
