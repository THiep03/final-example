package com.datn.backend.dto;

public class LessonInteractionReactionResponse {

    private String action;

    public LessonInteractionReactionResponse(String action) {
        this.action = action;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }
}
