package com.pawconnect.model;

public class Category {
    private int categoryId;
    private String categoryName;
    private String description;
    private String imageUrl;
    private boolean isActive;
    private int petCount;

    public Category() {}

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    public int getPetCount() { return petCount; }
    public void setPetCount(int petCount) { this.petCount = petCount; }
}
