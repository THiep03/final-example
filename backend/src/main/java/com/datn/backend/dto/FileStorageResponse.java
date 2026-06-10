package com.datn.backend.dto;

import com.datn.backend.entity.FileStorage;

import java.time.LocalDateTime;

public class FileStorageResponse {

    private Long id;
    private String fileName;
    private String fileType;
    private String storageProvider;
    private String fileUrl;
    private String driveFileId;
    private String mimeType;
    private Long fileSize;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public static FileStorageResponse from(FileStorage fileStorage) {
        FileStorageResponse response = new FileStorageResponse();
        response.setId(fileStorage.getId());
        response.setFileName(fileStorage.getFileName());
        response.setFileType(fileStorage.getFileType());
        response.setStorageProvider(fileStorage.getStorageProvider());
        response.setFileUrl(fileStorage.getFileUrl());
        response.setDriveFileId(fileStorage.getDriveFileId());
        response.setMimeType(fileStorage.getMimeType());
        response.setFileSize(fileStorage.getFileSize());
        response.setCreatedAt(fileStorage.getCreatedAt());
        response.setUpdatedAt(fileStorage.getUpdatedAt());
        return response;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getStorageProvider() {
        return storageProvider;
    }

    public void setStorageProvider(String storageProvider) {
        this.storageProvider = storageProvider;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getDriveFileId() {
        return driveFileId;
    }

    public void setDriveFileId(String driveFileId) {
        this.driveFileId = driveFileId;
    }

    public String getMimeType() {
        return mimeType;
    }

    public void setMimeType(String mimeType) {
        this.mimeType = mimeType;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
