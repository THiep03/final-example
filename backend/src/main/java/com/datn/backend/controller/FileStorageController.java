package com.datn.backend.controller;

import com.datn.backend.dto.FileStorageRequest;
import com.datn.backend.dto.FileStorageResponse;
import com.datn.backend.service.FileStorageService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/files")
public class FileStorageController {

    private final FileStorageService fileStorageService;

    public FileStorageController(FileStorageService fileStorageService) {
        this.fileStorageService = fileStorageService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public FileStorageResponse createFile(@Valid @RequestBody FileStorageRequest request) {
        return fileStorageService.createFile(request);
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseStatus(HttpStatus.CREATED)
    public FileStorageResponse uploadFile(@RequestParam("file") MultipartFile file,
                                          @RequestParam("fileType") String fileType) {
        return fileStorageService.uploadFile(file, fileType);
    }

    @GetMapping
    public List<FileStorageResponse> getAllFiles() {
        return fileStorageService.getAllFiles();
    }

    @GetMapping("/{id}")
    public FileStorageResponse getFileById(@PathVariable Long id) {
        return fileStorageService.getFileById(id);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteFile(@PathVariable Long id) {
        fileStorageService.deleteFile(id);
    }
}
