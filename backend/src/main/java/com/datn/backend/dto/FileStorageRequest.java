package com.datn.backend.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public class FileStorageRequest {

    @NotBlank(message = "File name is required")
    @Size(max = 255, message = "File name must be at most 255 characters")
    private String fileName;

    @Pattern(regexp = "video|image|document", message = "File type must be video, image, or document")
    private String fileType;

    @Pattern(regexp = "google_drive|local", message = "Storage provider must be google_drive or local")
    private String storageProvider;

    @Size(max = 500, message = "File URL must be at most 500 characters")
    private String fileUrl;

    @Size(max = 255, message = "Drive file ID must be at most 255 characters")
    private String driveFileId;

    @Size(max = 100, message = "MIME type must be at most 100 characters")
    private String mimeType;

    @Min(value = 0, message = "File size must be zero or positive")
    private Long fileSize;

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
}
