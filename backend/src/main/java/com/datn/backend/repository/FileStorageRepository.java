package com.datn.backend.repository;

import com.datn.backend.entity.FileStorage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FileStorageRepository extends JpaRepository<FileStorage, Long> {
}
