package com.datn.backend.dto;

import java.time.LocalDate;

public class UserUpdateRequest {

    private String name;
    private String email;
    private String role;
    private String currentLevel;
    private String phone;
    private LocalDate dateOfBirth;
    private String gender;
    private String school;
    private String bio;

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getCurrentLevel() { return currentLevel; }
    public void setCurrentLevel(String currentLevel) { this.currentLevel = currentLevel; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getSchool() { return school; }
    public void setSchool(String school) { this.school = school; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
}
