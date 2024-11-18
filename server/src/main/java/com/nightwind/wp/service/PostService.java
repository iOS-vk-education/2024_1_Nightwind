package com.nightwind.wp.service;

import com.nightwind.wp.config.PropertiesConfig;
import org.springframework.stereotype.Service;
import com.nightwind.wp.domain.Post;
import com.nightwind.wp.domain.User;
import com.nightwind.wp.form.WritePostForm;
import com.nightwind.wp.repository.PostRepository;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@Service
public class PostService {
    private final PropertiesConfig propertiesConfig;

    private final PostRepository postRepository;

    public PostService(PropertiesConfig propertiesConfig,
                       PostRepository postRepository) {
        this.propertiesConfig = propertiesConfig;
        this.postRepository = postRepository;
    }

    public Post findById(long id) {
        return postRepository.findById(id).orElse(null);
    }

    public List<Post> findAll() {
        return postRepository.findAllByOrderByCreationTimeDesc();
    }

    public Post writePost(WritePostForm form, User author) throws IOException {
        Post post = new Post();
        post.setTitle(form.getTitle());
        post.setText(form.getText());
        post.setMedia(saveMediaAndGetKeys(form.getMedia(), post.getId() + "_"));
        post.setUser(author);

        this.postRepository.save(post);

        return post;
    }

    public Post getAndIncrementViewCount(Long postId) {
        Post post = postRepository.findById(postId).orElse(null);

        if (post != null) {
            post.incrementViewCount();
            postRepository.save(post);
        }

        return post;
    }

    private List<String> saveMediaAndGetKeys(List<MultipartFile> media, String keyPrefix) throws IOException {
        List<String> keys = new ArrayList<>();

        if (media == null || media.isEmpty()) {
            return keys;
        }

        // Get the directory path from config properties
        Path uploadDir = Paths.get(propertiesConfig.getMediaDir());

        // Ensure the directory exists
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
        }

        for (int i = 0; i < media.size(); ++i) {
            var file = media.get(i);

            if (!file.isEmpty()) {
                // Get the original filename to preserve the extension
                String originalFilename = file.getOriginalFilename();
                String extension = ""; // Default to an empty string

                if (originalFilename != null) {
                    // Extract the file extension
                    int lastDotIndex = originalFilename.lastIndexOf('.');
                    if (lastDotIndex > 0 && lastDotIndex < originalFilename.length() - 1) {
                        extension = originalFilename.substring(lastDotIndex); // Include the dot
                    }
                }

                // Construct the full file name, preserving the file extension
                String key = keyPrefix + i + extension;
                Path path = uploadDir.resolve(key); // Combine directory and key

                // Write the file
                Files.write(path, file.getBytes());
                keys.add(key);
            }
        }

        return keys;
    }
}
