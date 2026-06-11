package com.datn.backend.service;

import com.datn.backend.constants.AppConstants;
import com.datn.backend.dto.FileStorageRequest;
import com.datn.backend.dto.FileStorageResponse;
import com.datn.backend.entity.FileStorage;
import com.datn.backend.repository.FileStorageRepository;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class FileStorageService {

    private static final String LOCAL_BASE_URL = "http://localhost:8080/uploads";

    private final FileStorageRepository fileStorageRepository;

    public FileStorageService(FileStorageRepository fileStorageRepository) {
        this.fileStorageRepository = fileStorageRepository;
    }

    @Transactional
    public FileStorageResponse createFile(FileStorageRequest request) {
        FileStorage fileStorage = new FileStorage();
        fileStorage.setFileName(request.getFileName());
        if (request.getFileType() != null && !request.getFileType().isBlank()) {
            fileStorage.setFileType(request.getFileType());
        }
        if (request.getStorageProvider() != null && !request.getStorageProvider().isBlank()) {
            fileStorage.setStorageProvider(request.getStorageProvider());
        }
        fileStorage.setFileUrl(request.getFileUrl());
        fileStorage.setDriveFileId(request.getDriveFileId());
        fileStorage.setMimeType(request.getMimeType());
        fileStorage.setFileSize(request.getFileSize());

        return FileStorageResponse.from(fileStorageRepository.save(fileStorage));
    }

    @Transactional
    public FileStorageResponse uploadFile(MultipartFile file, String fileType) {
        if (file == null || file.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Uploaded file is required");
        }

        String normalizedFileType = normalizeFileType(fileType);
        String folderName = getFolderName(normalizedFileType);
        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename() == null
                ? "uploaded-file"
                : file.getOriginalFilename());
        String safeFileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String storedFileName = UUID.randomUUID() + "-" + safeFileName;

        try {
            Path uploadDirectory = Paths.get("uploads", folderName).toAbsolutePath().normalize();
            Files.createDirectories(uploadDirectory);

            Path targetPath = uploadDirectory.resolve(storedFileName).normalize();
            if (!targetPath.startsWith(uploadDirectory)) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid file name");
            }

            file.transferTo(targetPath);

            FileStorage fileStorage = new FileStorage();
            fileStorage.setFileName(originalFileName);
            fileStorage.setFileType(normalizedFileType);
            fileStorage.setStorageProvider(AppConstants.StorageProvider.LOCAL);
            fileStorage.setFileUrl(LOCAL_BASE_URL + "/" + folderName + "/" + storedFileName);
            fileStorage.setDriveFileId(null);
            fileStorage.setMimeType(file.getContentType());
            fileStorage.setFileSize(file.getSize());

            return FileStorageResponse.from(fileStorageRepository.save(fileStorage));
        } catch (IOException exception) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Could not store uploaded file");
        }
    }

    @Transactional(readOnly = true)
    public List<FileStorageResponse> getAllFiles() {
        return fileStorageRepository.findAll()
                .stream()
                .map(FileStorageResponse::from)
                .toList();
    }

    @Transactional(readOnly = true)
    public FileStorageResponse getFileById(Long id) {
        return fileStorageRepository.findById(id)
                .map(FileStorageResponse::from)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "File metadata not found"));
    }

    @Transactional
    public void deleteFile(Long id) {
        FileStorage fileStorage = fileStorageRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "File metadata not found"));

        if (AppConstants.StorageProvider.LOCAL.equals(fileStorage.getStorageProvider()) && fileStorage.getFileUrl() != null) {
            String fileUrl = fileStorage.getFileUrl();
            String uploadsPrefix = LOCAL_BASE_URL + "/";
            if (fileUrl.startsWith(uploadsPrefix)) {
                String relativePath = fileUrl.substring(uploadsPrefix.length());
                Path filePath = Paths.get("uploads", relativePath).toAbsolutePath().normalize();
                try {
                    Files.deleteIfExists(filePath);
                } catch (IOException ignored) {
                }
            }
        }

        fileStorageRepository.delete(fileStorage);
    }

    private String normalizeFileType(String fileType) {
        if (fileType == null || fileType.isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "File type is required");
        }

        String normalizedFileType = fileType.trim().toLowerCase();
        if (!normalizedFileType.equals(AppConstants.FileType.VIDEO)
                && !normalizedFileType.equals(AppConstants.FileType.IMAGE)
                && !normalizedFileType.equals(AppConstants.FileType.DOCUMENT)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "File type must be video, image, or document");
        }

        return normalizedFileType;
    }

    private String getFolderName(String fileType) {
        if (AppConstants.FileType.IMAGE.equals(fileType)) {
            return AppConstants.FileFolder.IMAGES;
        }
        if (AppConstants.FileType.DOCUMENT.equals(fileType)) {
            return AppConstants.FileFolder.DOCUMENTS;
        }
        return AppConstants.FileFolder.VIDEOS;
    }
}
